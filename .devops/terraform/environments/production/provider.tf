# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

provider "github" {
  token = var.github_token # or `GITHUB_TOKEN`
}
