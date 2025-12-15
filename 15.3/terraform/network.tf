# resource "yandex_vpc_network" "network" {
#   name = "lamp-network"
# }

# # resource "yandex_vpc_subnet" "subnet" {
# #   name           = "lamp-subnet"
# #   zone           = var.zone
# #   network_id     = yandex_vpc_network.network.id
# #   v4_cidr_blocks = ["192.168.10.0/24"]
# # }

# # Создаем подсети в разных зонах
# resource "yandex_vpc_subnet" "subnet_a" {
#   name           = "subnet-a"
#   zone           = "ru-central1-a"
#   network_id     = yandex_vpc_network.network.id
#   v4_cidr_blocks = ["192.168.10.0/24"]
# }

# resource "yandex_vpc_subnet" "subnet_b" {
#   name           = "subnet-b"
#   zone           = "ru-central1-b"
#   network_id     = yandex_vpc_network.network.id
#   v4_cidr_blocks = ["192.168.20.0/24"]
# }

# resource "yandex_vpc_subnet" "subnet_d" {
#   name           = "subnet-d"
#   zone           = "ru-central1-d"  
#   network_id     = yandex_vpc_network.network.id
#   v4_cidr_blocks = ["192.168.30.0/24"]
# }