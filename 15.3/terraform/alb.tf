# resource "yandex_vpc_security_group" "alb-sg" {
#   name       = "alb-security-group"
#   network_id = yandex_vpc_network.network.id
  
#   ingress {
#     protocol       = "TCP"
#     description    = "HTTP from internet"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     port           = 80
#   }
  
#   egress {
#     protocol       = "ANY"
#     description    = "Outbound traffic"
#     v4_cidr_blocks = ["0.0.0.0/0"]
#     from_port      = 0
#     to_port        = 65535
#   }
# }