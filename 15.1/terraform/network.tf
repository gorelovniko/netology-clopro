# VPC
resource "yandex_vpc_network" "vpc" {
  name = "netology-hw-vpc"
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
  # Attach route table to private subnet
  route_table_id = yandex_vpc_route_table.private_rt.id
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
