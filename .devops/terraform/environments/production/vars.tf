variable "do_token" {
  description = "DigitalOcean API token"
  type = string
  sensitive = true
}

variable "github_token" {
  description = "GitHub API token"
  type = string
  sensitive = true
}

variable "cloudflare_token" {
  description = "Cloudflare API token"
  type = string
  sensitive = true
}