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