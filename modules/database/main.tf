terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

# Pulls the image
resource "docker_image" "db" {
  name = var.image
  keep_locally = true
}

# Create a container db
resource "docker_container" "db" {
  image = docker_image.db.image_id
  name  = "db"
  env = [
    "POSTGRES_USER=${var.PG_USER}",
    "POSTGRES_PASSWORD=${var.PG_PWD}",
    "POSTGRES_DB=${var.PG_DB_NAME}"
  ]
  networks_advanced {
    name = var.my_network
  }
}