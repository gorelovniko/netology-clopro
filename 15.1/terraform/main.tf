provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

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
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1" # Ubuntu 22.04
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat        = true  # публичный IP для NAT
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Route table for private subnet
resource "yandex_vpc_route_table" "private_rt" {
  name       = "private-route-table"
  network_id = yandex_vpc_network.vpc.id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}

# Attach route table to private subnet
resource "yandex_vpc_subnet" "private_with_rt" {
  name           = "private"
  network_id     = yandex_vpc_network.vpc.id
  zone           = var.yc_zone
  v4_cidr_blocks = ["192.168.20.0/24"]
  route_table_id = yandex_vpc_route_table.private_rt.id
}

# Public instance (jump host)
resource "yandex_compute_instance" "public_vm" {
  name        = "public-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}

# Private instance (no public IP)
resource "yandex_compute_instance" "private_vm" {
  name        = "private-vm"
  platform_id = "standard-v1"
  zone        = var.yc_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.private_with_rt.id
    # nat = false by default
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}