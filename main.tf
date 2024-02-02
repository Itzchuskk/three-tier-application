terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}


# variable "environments" {
#   default = ["dev", "prod"]
# }

# variable "port_ui" {
#   default = ["8080", "8081"]
# }

# variable "port_api" {
#   default = ["5000", "5050"]
# }

# locals {
#   envs = { for idx, name in var.environments:
#               name => {
#                 env_name = name
#                 ui_p = var.port_ui[idx]
#                 ui_api = var.port_api[idx]
#               }
#   }
# }
variable "environment" {
  type = object({
    name     = string
    port_ui  = string
    port_api = string
  })
  # default = {
  #   name     = "dev"
  #   port_ui  = "8080"
  #   port_api = "5000"
  # }
}

provider "docker" {}

resource "docker_network" "local_network" {
  name       = "local_network_${var.environment.name}"
  attachable = true
}

module "database" {
  source         = "./modules/database"
  module_network = docker_network.local_network.id
  image_tag      = var.environment.name
}

module "frontend" {
  source         = "./modules/frontend"
  module_network = docker_network.local_network.id
  port_external  = var.environment.port_ui
  image_tag      = var.environment.name
}

module "backend" {
  source         = "./modules/backend"
  module_network = docker_network.local_network.id
  port_external  = var.environment.port_api
  image_tag      = var.environment.name
  db_addr        = module.database.db_addr
}

