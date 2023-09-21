terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

locals {
  zone = "ru-central1-a"
}

provider "yandex" {
  token = "${tv_ya_token}"
  cloud_id = "${tv_ya_cloud_id}"
  folder_id = "b1g6k2i3lobiesnh55af"
  zone = local.zone
}

resource "yandex_compute_instance" "jenkins" {
  name                      = "jenkins"
  allow_stopping_for_update = true
  platform_id               = "standard-v1"
  zone                      = local.zone

  resources {
    core_fraction = 5
    cores  = "2"
    memory = "2"
  }

  boot_disk {
    initialize_params {
      image_id = "fd891ub8nj4kg2g9o383"   #jenkins
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.subnet-1.id}"
    nat       = true
  }

  scheduling_policy {
  preemtible = true
   }


 metadata = {
    user-data = "${file("./meta.yaml")}"
  }

}

resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
#  zone           = "<зона_доступности>"
  v4_cidr_blocks = ["192.168.10.0/24"]
  network_id     = "${yandex_vpc_network.network-1.id}"
}


