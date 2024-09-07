#######################################################
############# DigitalOcean Resources ##################
#######################################################
locals {
  environment  = "production"
  project_name = "stone-sre-devopos-challenge"
}

data "digitalocean_project" "main" {
  name = local.environment
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

resource "digitalocean_kubernetes_cluster" "main" {
  name         = "${local.project_name}-${local.environment}-k8s"
  region       = "nyc1"
  auto_upgrade = true
  version      = "1.30.4-do.0"

  maintenance_policy {
    start_time = "04:00"
    day        = "sunday"
  }

  node_pool {
    name       = "${local.project_name}-${local.environment}-pool"
    size       = "s-1vcpu-2gb"
    node_count = 1
  }
}

# Project Resources
resource "digitalocean_project_resources" "main" {
  project = data.digitalocean_project.main.id
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

resource "github_repository_environment" "environment" {
  repository  = data.github_repository.main.name
  environment = local.environment
}

resource "github_actions_environment_secret" "main" {
  for_each = {
    DB_PASSWORD = digitalocean_database_cluster.main.password
    DB_USER     = digitalocean_database_cluster.main.user
    APP_KEY     = "H5TfJkzRDwDw_Hj5-FRu6hZJRXszYT8J"
    DIGITALOCEAN_ACCESS_TOKEN = var.do_token
  }

  repository      = data.github_repository.main.name
  environment     = local.environment
  secret_name     = each.key
  plaintext_value = each.value
}

resource "github_actions_environment_variable" "main" {
  for_each = {
    DB_HOST = digitalocean_database_cluster.main.host
    DB_PORT = digitalocean_database_cluster.main.port
    DB_DATABASE = digitalocean_database_cluster.main.database
  }

  repository    = data.github_repository.main.name
  environment   = local.environment
  variable_name = each.key
  value         = each.value
}