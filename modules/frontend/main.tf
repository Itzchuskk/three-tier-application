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