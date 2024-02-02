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

# Pulls the image
resource "docker_image" "db" {
  name = "postgres:14"
  keep_locally = true
}

# Create a container db
resource "docker_container" "db" {
  image = docker_image.db.image_id
  name  = "db"
  env = [
    "POSTGRES_USER=user",
    "POSTGRES_PASSWORD=pass",
    "POSTGRES_DB=feedback"
  ]
  networks_advanced {
    name = docker_network.local_network.id
  }
}

# Builds the image ui
resource "docker_image" "ui" {
  name = "ui"
  keep_locally = true
  build {
    context = "./front-end/"
  }
}

# Create a container ui
resource "docker_container" "ui" {
  image = docker_image.ui.image_id
  name  = "ui"
  ports {
    internal = "80"
    external = "8081"
  }
  networks_advanced {
    name = docker_network.local_network.id
  }
}

# Builds the image api
resource "docker_image" "api" {
  name = "api"
  keep_locally = true
  build {
    context = "./back-end/"
  }
}

# Create a container api
resource "docker_container" "api" {
  image = docker_image.api.image_id
  name  = "api"
  ports {
    internal = "8000"
    external = "5000"
  }
  command = ["-w", "4", "-b", "0.0.0.0:8000"]
  env = [
    "DB_URL=postgresql://user:pass@db:5432/feedback"
  ]
  networks_advanced {
    name = docker_network.local_network.id
  }
}