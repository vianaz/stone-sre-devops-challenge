provider "aws" {
  region = var.aws_region
  access_key = var.access_key
  secret_key = var.secret_key
}

provider "github" {
  token = var.github_token # or `GITHUB_TOKEN`
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

provider "neon" {
  api_key = var.neon_api_key
}

# provider "kubernetes" {
#   host  = data.digitalocean_kubernetes_cluster.main.kube_config.0.host
#   token = data.digitalocean_kubernetes_cluster.main.kube_config.0.token
#   cluster_ca_certificate = base64decode(
#     data.digitalocean_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate
#   )
# }