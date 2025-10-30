terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0.0"

  cluster_name    = "prod-self-healing-cluster"
  cluster_version = "1.27"

  vpc_id     = "vpc-12345" # (This would be our real VPC)
  subnet_ids = ["subnet-abc", "subnet-def"]

  eks_managed_node_groups = {
    main = {
      min_size     = 1
      max_size     = 10
      desired_size = 3
      instance_type = "t3.medium"
    }
  }
}
