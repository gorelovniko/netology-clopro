# # VPC
# resource "yandex_vpc_network" "vpc" {
#   name = "homework-vpc"
# }

# # Public subnet
# resource "yandex_vpc_subnet" "public" {
#   name       = "public"
#   network_id = yandex_vpc_network.vpc.id
#   zone       = var.yc_zone
#   v4_cidr_blocks = ["192.168.10.0/24"]
# }

# # Private subnet
# resource "yandex_vpc_subnet" "private" {
#   name       = "private"
#   network_id = yandex_vpc_network.vpc.id
#   zone       = var.yc_zone
#   v4_cidr_blocks = ["192.168.20.0/24"]
# }

resource "yandex_vpc_network" "network" {
  name = "lamp-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "lamp-subnet"
  zone           = var.zone
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

