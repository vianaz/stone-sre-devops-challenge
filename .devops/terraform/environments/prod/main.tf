locals {
  environment  = "production"
  project_name = "stone-sre-devopos-challenge"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name           = "${local.project_name}-${local.environment}-eks-vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  map_public_ip_on_launch = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.30.1"

  cluster_name    = "${local.environment}-eks-cluster"
  cluster_version = "1.31"
  cluster_endpoint_public_access  = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = {
    main = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3a.medium"]
      capacity_type = "SPOT"

      min_size     = 1
      max_size     = 5
      desired_size = 3
    }
  }
}

module "github-oidc" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "~> 2"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = ["vianaz/stone-sre-devops-challenge"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}