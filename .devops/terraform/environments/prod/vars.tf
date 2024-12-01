variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "access_key" {
  description = "AWS access key"
  type = string
  sensitive = true
}

variable "secret_key" {
  description = "AWS secret key"
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

variable "neon_api_key" {
  description = "Neon DB API key"
  type = string
  sensitive = true
}