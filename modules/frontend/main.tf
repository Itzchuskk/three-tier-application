terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Builds the image ui
resource "docker_image" "ui" {
  name = "ui:${var.image_tag}"
  keep_locally = true
  build {
    context = "./front-end/"
  }
}

# Create a container ui
resource "docker_container" "ui" {
  image = docker_image.ui.image_id
  name  = "ui_${var.image_tag}"
  ports {
    internal = "80"
    external = var.port_external
  }
  networks_advanced {
    name = var.module_network
  }
}