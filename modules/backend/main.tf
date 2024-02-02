terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Builds the image api
resource "docker_image" "api" {
  name = "api:${var.image_tag}"
  keep_locally = true
  build {
    context = "./back-end/"
  }
}

# Create a container api
resource "docker_container" "api" {
  image = docker_image.api.image_id
  name  = "api_${var.image_tag}"
  ports {
    internal = "8000"
    external = var.port_external
  }
  command = ["-w", "4", "-b", "0.0.0.0:8000"]
  env = [
    "DB_URL=postgresql://user:pass@${var.db_addr}:5432/feedback"
  ]
  networks_advanced {
    name = var.module_network
  }
}