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
  name       = var.my_global_network
  attachable = true
}

module database {
  source = "./modules/database"
  my_network = var.my_global_network
}

module frontend {
  source = "./modules/frontend"
  my_network = var.my_global_network
}

module backend {
  source = "./modules/backend"
  my_network = var.my_global_network
}
