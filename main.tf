terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.74.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"  

  shared_config_files      = ["C:/Users/<user>/.aws/config"]
  shared_credentials_files = ["C:/Users/<user>/.aws/credentials"]

  default_tags {
  }
}

provider "kubernetes" {
  host = data.aws_eks_cluster.host.endpoint
  token = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.host.certificate_authority[0].data)
}

module "cluster-eks" {
  source = "./modules/EKS"
  cluster_name = "darede-eks"
  nodes_name = "darede-nodes"
  service_role_arn = "arn:aws:iam::123456789012:role/eks-service-role"
  instance_role_arn = "arn:aws:iam::123456789012:role/eks-instance-role"
}

module "vpc" {
  source = "./modules/VPC"
  vpc_name = "darede-vpc"
  vpc_cidr = "172.16.0.0/16"
  azs = ["us-east-1a", "us-east-1b"]
  public_subnets = ["172.16.1.0/24", "172.16.2.0/24"]
  private_subnets = ["172.16.3.0/24", "172.16.4.0/24"]
}

