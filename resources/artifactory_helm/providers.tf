terraform {
  required_providers {
    # kubernetes = {
    #   source  = "hashicorp/kubernetes"
    #   version = "2.31.0"
    # }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.25.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}
