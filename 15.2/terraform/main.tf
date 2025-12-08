# VPC
resource "yandex_vpc_network" "vpc" {
  name = "homework-vpc"
}

# Public subnet
resource "yandex_vpc_subnet" "public" {
  name       = "public"
  network_id = yandex_vpc_network.vpc.id
  zone       = var.yc_zone
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# Private subnet
resource "yandex_vpc_subnet" "private" {
  name       = "private"
  network_id = yandex_vpc_network.vpc.id
  zone       = var.yc_zone
  v4_cidr_blocks = ["192.168.20.0/24"]
}

# NAT instance (in public subnet)
resource "yandex_compute_instance" "nat" {
  name        = "nat-instance"
  hostname    = "nat"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id # Ubuntu 22.04
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true  # публичный IP для NAT
  }

  metadata = {
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data          = file("./cloud-init.yml")
  }

  scheduling_policy {preemptible = true}
}



# Public instance (jump host)
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  hostname    = "public-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data          = file("./cloud-init.yml")
  }
  
  scheduling_policy {preemptible = true}

}

# Private instance (no public IP)
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  hostname    = "private-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores = 2
    memory = 2
    core_fraction = 20
  }

  boot_disk {
    initialize_params {
      image_id = var.yc_image_id
      size     = 10
      type     = "network-hdd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
    # nat = false by default
  }

  metadata = {
    # ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    user-data          = file("./cloud-init.yml")
  }

  scheduling_policy {preemptible = true}
  
}
