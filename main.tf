terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_network" "local_network" {
  name       = "local_network"
  attachable = true
}

module "database" {
    source = "./modules/database"
}

module "frontend" {
    source = "./modules/frontend"
}

module "backend" {
    source = "./modules/backend"
}

