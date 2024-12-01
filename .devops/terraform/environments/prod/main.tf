locals {
  environment  = "production"
  project_name = "stone-sre-devopos-challenge"
}

############### AWS ################
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.16.0"

  name           = "${local.project_name}-${local.environment}-eks-vpc"
  cidr           = "10.0.0.0/16"
  azs            = ["us-east-1a", "us-east-1b"]
  public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

  map_public_ip_on_launch = true
}
module "github-oidc" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "~> 2"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories              = ["vianaz/stone-sre-devops-challenge"]
  oidc_role_attach_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
}
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.30.1"

  cluster_name                   = "${local.environment}-eks-cluster"
  cluster_version                = "1.31"
  cluster_endpoint_public_access = true

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnets

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  access_entries = {
    github-oidc = {
      principal_arn = module.github-oidc.oidc_role
      policy_associations = {
        admin-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
        view-admin-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAdminViewPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
        cluster-admin-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = ["default"]
            type       = "namespace"
          }
        }
      }
    }
  }

  eks_managed_node_groups = {
    main = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["t3a.medium"]
      capacity_type  = "SPOT"

      min_size     = 1
      max_size     = 5
      desired_size = 3
    }
  }
}


############### GITHUB ################
data "github_repository" "main" {
  full_name = "vianaz/stone-sre-devops-challenge"
}
data "github_user" "current" {
  username = "vianaz"
}
resource "github_repository_environment" "environment" {
  repository        = data.github_repository.main.name
  environment       = local.environment
  can_admins_bypass = false
  # reviewers {
  #   users = [ data.github_user.current.id ]
  # }
  deployment_branch_policy {
    protected_branches     = false
    custom_branch_policies = true
  }
}
resource "github_actions_environment_secret" "main" {
  for_each = {
    AWS_ROLE_ARN     = module.github-oidc.oidc_role
    EKS_CLUSTER_NAME = module.eks.cluster_name
    APP_KEY          = "H5TfJkzRDwDw_Hj5-FRu6hZJRXszYT8J"
    DB_HOST          = "postgres"
    DB_USER          = "postgres"
    DB_PASSWORD      = "postgres"
    DB_DATABASE      = "postgres"
  }

  repository      = data.github_repository.main.name
  environment     = local.environment
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_environment_variable" "main" {
  for_each = {
    ENVIRONMENT  = local.environment
    PROJECT_NAME = local.project_name
    DB_PORT          = "5432"
  }

  repository    = data.github_repository.main.name
  environment   = local.environment
  variable_name = each.key
  value         = each.value
}
