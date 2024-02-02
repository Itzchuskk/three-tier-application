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
