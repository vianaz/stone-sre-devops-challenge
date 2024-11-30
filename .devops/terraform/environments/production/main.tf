#######################################################
############# DigitalOcean Resources ##################
#######################################################
locals {
  environment  = "production"
  project_name = "stone-sre-devopos-challenge"
}

resource "digitalocean_project" "main" {
  name        =  local.environment
  description = "A project that have production infra resources"
  purpose     = "Other"
}

# Database Cluster
resource "digitalocean_database_cluster" "main" {
  name       = "${local.project_name}-${local.environment}-db"
  engine     = "pg"
  version    = "16"
  size       = "db-s-1vcpu-1gb"
  region     = "nyc1"
  node_count = 1
}

# Kubernetes Cluster
resource "digitalocean_kubernetes_cluster" "main" {
  name         = "${local.project_name}-${local.environment}-k8s"
  region       = "nyc1"
  auto_upgrade = true
  version      = "1.31.1-do.4"
  destroy_all_associated_resources = true

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "${local.project_name}-${local.environment}-pool"
    size       = "s-1vcpu-2gb"
    node_count = 2
  }
}

# Project Resources
resource "digitalocean_project_resources" "main" {
  project = digitalocean_project.main.id
  resources = [
    digitalocean_database_cluster.main.urn,
    digitalocean_kubernetes_cluster.main.urn
  ]
}

#######################################################
############# GitHub Repository Integration ###########
#######################################################
data "github_repository" "main" {
  full_name = "vianaz/stone-sre-devops-challenge"
}

data "github_user" "current" {
  username = "vianaz"
}

resource "github_repository_environment" "environment" {
  repository  = data.github_repository.main.name
  environment = local.environment

  can_admins_bypass = false
  reviewers {
    users = [ data.github_user.current.id ]
  }
  deployment_branch_policy {
    protected_branches = false
    custom_branch_policies = true
  }
}

resource "github_actions_environment_secret" "main" {
  depends_on = [ github_repository_environment.environment, digitalocean_database_cluster.main, digitalocean_kubernetes_cluster.main ]
  for_each = {
    DB_PASSWORD = digitalocean_database_cluster.main.password
    DB_USER     = digitalocean_database_cluster.main.user
    APP_KEY     = "H5TfJkzRDwDw_Hj5-FRu6hZJRXszYT8J"
    DIGITALOCEAN_ACCESS_TOKEN = var.do_token
    K8S_CLUSTER_ID = digitalocean_kubernetes_cluster.main.id
    DB_HOST = digitalocean_database_cluster.main.host
  }

  repository      = data.github_repository.main.name
  environment     = local.environment
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_environment_variable" "main" {
  depends_on = [ github_repository_environment.environment, digitalocean_database_cluster.main ]
  for_each = {
    DB_PORT = digitalocean_database_cluster.main.port
    DB_DATABASE = digitalocean_database_cluster.main.database
    APP_URL                 = "https://${cloudflare_record.main.hostname}"
  }

  repository    = data.github_repository.main.name
  environment   = local.environment
  variable_name = each.key
  value         = each.value
}

########################################################
################## Kubernetes #########################
######################################################
data "kubernetes_service" "main" {
  metadata {
    name = "api"
  }
}

########################################################
################## CloudFlare #########################
######################################################
data "cloudflare_zone" "main" {
  name = "vianaz.online"
}
resource "cloudflare_record" "main" {
  zone_id = data.cloudflare_zone.main.id
  name    = "api"
  content = data.kubernetes_service.main.status.0.load_balancer.0.ingress.0.ip
  type    = "A"
  ttl     = 1
  proxied = true
}