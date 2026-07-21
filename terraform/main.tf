terraform {
  required_version = ">= 1.5"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

variable "image_tag" {
  description = "Tag of the locally built image, supplied by Jenkins BUILD_NUMBER"
  type        = string
  default     = "latest"
}

# Reads an image that already exists on the local daemon.
# Does not attempt a registry pull.
data "docker_image" "app" {
  name = "cicd-demo-app:${var.image_tag}"
}

resource "docker_container" "app" {
  name     = "cicd-demo-app"
  image    = data.docker_image.app.id
  restart  = "unless-stopped"
  must_run = true

  ports {
    internal = 5000
    external = 8081
  }
}

output "container_name" {
  value = docker_container.app.name
}

output "app_url" {
  value = "http://localhost:8081"
}
