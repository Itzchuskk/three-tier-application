terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Pulls the image
resource "docker_image" "this" {
  name = "postgres:14"
  keep_locally = true
}

# Create a container db
resource "docker_container" "db" {
  image = docker_image.this.image_id
  name  = "db_${var.image_tag}"
  env = [
    "POSTGRES_USER=user",
    "POSTGRES_PASSWORD=pass",
    "POSTGRES_DB=feedback"
  ]
  networks_advanced {
    name = var.module_network
  }
}
