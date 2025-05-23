terraform{
  required_providers{
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  } 
}

provider "aws" {
  region = var.region
}

# create a VPC
locals {
  private_subnets = [for idx, az in var.availability_zones : cidrsubnet(var.vpc_cidr_block, 8, idx)]
  public_subnets = [for idx, az in var.availability_zones : cidrsubnet(var.vpc_cidr_block, 8, idx + 100)]
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"

  name = "${var.cluster_name}-vpc"
  cidr = var.vpc_cidr_block

  azs             = var.availability_zones
  private_subnets = local.private_subnets
  public_subnets  = local.public_subnets

  enable_nat_gateway = true
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.cluster_name}-vpc"
  }
}

resource "aws_security_group" "cluster_remote_access" {
  count = var.enable_remote_access ? 1 : 0

  name        = "${var.cluster_name}-ra"
  description = "Allow SSH access from my IP"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "SSH from my IP"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.cluster_name}-ra"
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  # version = "20.36.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_addons = {
    aws-ebs-csi-driver = {
      service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    }
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    one = merge({
      name = "${var.cluster_name}-ng-1"
      #ami_type = "AL2_x86_64" - leave unset for latest
      instance_types = [var.node_group_instance_type]
      capacity_type = "SPOT"
      disk_size = 50
      min_size     = var.node_group_min_size  
      max_size     = var.node_group_max_size
      desired_size = var.node_group_desired_size
      tags = {
        Name = "${var.cluster_name}-ng-1"
      }
    },
    var.enable_remote_access ? {
      remote_access = {
          ec2_ssh_key = var.key_name
          source_security_group_ids = [aws_security_group.cluster_remote_access.0.id]
        }
      } : {}
    )
  }
}

# https://aws.amazon.com/blogs/containers/amazon-ebs-csi-driver-is-now-generally-available-in-amazon-eks-add-ons/ 
data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "irsa-ebs-csi" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  #version = "5.39.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]

  tags = {
    Name = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  }
}
  