# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "github" {
  token = var.github_token # or `GITHUB_TOKEN`
}

provider "cloudflare" {
  api_token = var.cloudflare_token
}

# data "digitalocean_kubernetes_cluster" "main" {
#   name = digitalocean_kubernetes_cluster.main.name
# }
# provider "kubernetes" {
#   host  = data.digitalocean_kubernetes_cluster.main.kube_config.0.host
#   token = data.digitalocean_kubernetes_cluster.main.kube_config.0.token
#   cluster_ca_certificate = base64decode(
#     data.digitalocean_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate
#   )
# }