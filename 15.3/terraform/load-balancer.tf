# resource "yandex_lb_network_load_balancer" "nlb" {
#   name = "lamp-nlb"

#   listener {
#     name = "http"
#     port = 80
#     target_port = 80

#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }

#   attached_target_group {
#     target_group_id = yandex_lb_target_group.tg.id
    
#     healthcheck {
#       name = "http-healthcheck"
#       http_options {
#         port = 80
#         path = "/"
#       }
#     }
#   }
# }

# resource "yandex_lb_target_group" "tg" {
#   name = "lamp-tg"

#   dynamic "target" {
#     for_each = yandex_compute_instance_group.lamp_group.instances
#     content {
#       subnet_id = yandex_vpc_subnet.subnet_a.id
#       address   = target.value.network_interface.0.ip_address
#     }
#   }
# }