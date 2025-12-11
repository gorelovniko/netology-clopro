# Создание целевой группы
# resource "yandex_lb_target_group" "lamp-target-group" {
#   name      = "lamp-target-group"
#   region_id = "ru-central1"
  
#   dynamic "target" {
#     for_each = yandex_compute_instance_group.lamp-group.instances.*.id
    
#     content {
#       subnet_id = yandex_vpc_subnet.subnet.id
#       address   = yandex_compute_instance_group.lamp-group.instances[target.key].network_interface.0.ip_address
#     }
#   }
# }

resource "yandex_lb_target_group" "lamp-target-group" {
  name      = "lamp-target-group"
  region_id = "ru-central1"
  
  dynamic "target" {
    for_each = yandex_compute_instance_group.lamp-group.instances
    
    content {
      subnet_id = target.value.network_interface[0].subnet_id
      address   = target.value.network_interface[0].ip_address
    }
  }
}


# data "yandex_lb_target_group" "auto_created_tg" {
#   name = "lamp-instance-group-tg"  # Имя, которое вы указали в load_balancer.target_group_name
# }


# Создание сетевого балансировщика
resource "yandex_lb_network_load_balancer" "lamp-nlb" {
  name = "lamp-network-balancer"
  
  listener {
    name = "http-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  
  attached_target_group {
    target_group_id = yandex_lb_target_group.lamp-target-group.id
    # target_group_id = data.yandex_lb_target_group.auto_created_tg.id

    healthcheck {
      name = "http-healthcheck"
      http_options {
        port = 80
        path = "/"
      }
    }
  }
}