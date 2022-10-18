terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.22.0"
    }
  }
}

provider "docker" {}

provider "aws" {
  region     = "us-east-1"
  access_key    = var.access_key_id
  secret_key    = var.secret_access_key
}