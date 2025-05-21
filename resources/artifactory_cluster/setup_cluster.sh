#!/bin/bash
# get the kubeconfig for the EKS cluster
aws eks --region $(terraform output -raw region) update-kubeconfig --name $(terraform output -raw cluster_name)

# patch the storage class to make it the default
kubectl patch storageclass $(kubectl get storageclass -o jsonpath='{.items[?(@.provisioner=="kubernetes.io/aws-ebs")].metadata.name}') -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
