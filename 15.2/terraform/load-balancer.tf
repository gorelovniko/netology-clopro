# # Создание целевой группы
# # resource "yandex_lb_target_group" "lamp-target-group" {
# #   name      = "lamp-target-group"
# #   region_id = "ru-central1"
  
# #   dynamic "target" {
# #     for_each = yandex_compute_instance_group.lamp-group.instances.*.id
    
# #     content {
# #       subnet_id = yandex_vpc_subnet.subnet.id
# #       address   = yandex_compute_instance_group.lamp-group.instances[target.key].network_interface.0.ip_address
# #     }
# #   }
# # }

# resource "yandex_lb_target_group" "lamp-target-group" {
#   name      = "lamp-target-group"
#   region_id = "ru-central1"
  
#   dynamic "target" {
#     for_each = yandex_compute_instance_group.lamp-group.instances
    
#     content {
#       subnet_id = target.value.network_interface[0].subnet_id
#       address   = target.value.network_interface[0].ip_address
#     }
#   }
# }


# # data "yandex_lb_target_group" "auto_created_tg" {
# #   name = "lamp-instance-group-tg"  # Имя, которое вы указали в load_balancer.target_group_name
# # }


# # Создание сетевого балансировщика
# resource "yandex_lb_network_load_balancer" "lamp-nlb" {
#   name = "lamp-network-balancer"
  
#   listener {
#     name = "http-listener"
#     port = 80
#     external_address_spec {
#       ip_version = "ipv4"
#     }
#   }
  
#   attached_target_group {
#     target_group_id = yandex_lb_target_group.lamp-target-group.id
#     # target_group_id = data.yandex_lb_target_group.auto_created_tg.id

#     healthcheck {
#       name = "http-healthcheck"
#       http_options {
#         port = 80
#         path = "/"
#       }
#     }
#   }
# }


resource "yandex_lb_network_load_balancer" "nlb" {
  name = "lamp-nlb"

  listener {
    name = "http"
    port = 80
    target_port = 80

    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.tg.id
    #instance_group_id = yandex_compute_instance_group.lamp_group.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}

# resource "yandex_lb_target_group" "tg" {
#   name = "lamp-tg"

#   target {
#     subnet_id = var.public_subnet_id
#     address   = yandex_compute_instance_group.lamp_group.instance[0].network_interface[0].primary_v4_address
#   }

#   target {
#     subnet_id = var.public_subnet_id
#     address   = yandex_compute_instance_group.lamp_group.instance[1].network_interface[0].primary_v4_address
#   }

#   target {
#     subnet_id = var.public_subnet_id
#     address   = yandex_compute_instance_group.lamp_group.instance[2].network_interface[0].primary_v4_address
#   }
# }


resource "yandex_lb_target_group" "tg" {
  name = "lamp-tg"

  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp_group.instances
    content {
      subnet_id = yandex_vpc_subnet.subnet.id
      # subnet_id = var.subnet.network_id
      # address   = target.value.network_interfaces[0].primary_v4_address.address
      # address   = target.value.primary_v4_address
      address   = target.value.network_interface.0.ip_address
    }
  }
}
# //
# // Create a new NLB Target Group.
# //
# resource "yandex_lb_target_group" "my_tg" {
#   name      = "my-target-group"
#   region_id = "ru-central1"

#   target {
#     subnet_id = yandex_vpc_subnet.my-subnet.id
#     address   = yandex_compute_instance.my-instance-1.network_interface.0.ip_address
#   }

#   target {
#     subnet_id = yandex_vpc_subnet.my-subnet.id
#     address   = yandex_compute_instance.my-instance-2.network_interface.0.ip_address
#   }
# }