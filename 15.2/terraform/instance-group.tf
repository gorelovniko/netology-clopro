# Создание шаблона ВМ
resource "yandex_compute_instance_group" "lamp_group" {
  name               = "lamp-instance-group"
  folder_id          = var.yc_folder_id
  service_account_id = yandex_iam_service_account.vm-sa.id
  
  instance_template {
    platform_id = "standard-v3"
    # service_account_id = yandex_iam_service_account.vm-sa.id

    resources {
      memory = 2
      cores  = 2
    }
    
    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd827b91d99psvq5fjit" # LAMP образ
        size     = 10
      }
    }
    
    network_interface {
      network_id = yandex_vpc_network.network.id
      # subnet_ids = [
      #   yandex_vpc_subnet.subnet_a.id,  # ru-central1-a
      #   yandex_vpc_subnet.subnet_b.id,  # ru-central1-b  
      #   yandex_vpc_subnet.subnet_d.id   # ru-central1-d
      # ]
      nat        = true
    }
    
    metadata = {
      user-data          = file("./cloud-init.yml")
      user-data = <<-EOF
        #cloud-config
        package_update: true
        package_upgrade: true
        
        packages:
          - apache2
          - mysql-server
          - php
          - libapache2-mod-php
          - php-mysql
        
        runcmd:
          - systemctl enable apache2
          - systemctl start apache2
          - systemctl enable mysql
          - systemctl start mysql
          - echo "<?php phpinfo(); ?>" > /var/www/html/phpinfo.php
          # Здесь критически важно создать файл через HERE-doc в оболочке, а не в cloud-config
          # Используем 'sh -c' для правильного выполнения сложной команды
          - |
            sh -c "cat > /var/www/html/index.html <<'EOL'
            <!DOCTYPE html>
            <html lang=\"en\">
            <head>
                <meta charset=\"UTF-8\">
                <meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">
                <title>GorelovNN Netology</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        max-width: 1200px;
                        margin: 0 auto;
                        padding: 20px;
                        background-color: #f5f5f5;
                    }
                    .container {
                        background-color: white;
                        padding: 30px;
                        border-radius: 10px;
                        box-shadow: 0 2px 10px rgba(0,0,0,0.1);
                    }
                    h1 {
                        color: #333;
                        border-bottom: 2px solid #fc3f1d;
                        padding-bottom: 10px;
                    }
                    .image-container {
                        text-align: center;
                        margin: 30px 0;
                    }
                    .image-container img {
                        max-width: 100%;
                        height: auto;
                        border: 3px solid #ddd;
                        border-radius: 5px;
                        box-shadow: 0 4px 8px rgba(0,0,0,0.2);
                    }
                    .info {
                        background-color: #f9f9f9;
                        padding: 15px;
                        border-left: 4px solid #fc3f1d;
                        margin: 20px 0;
                    }
                    .metadata {
                        font-family: monospace;
                        background-color: #f0f0f0;
                        padding: 10px;
                        border-radius: 5px;
                        overflow-x: auto;
                    }
                </style>
            </head>
            <body>
                <div class=\"container\">
                    <h1>LAMP Instance - GorelovNN Netology</h1>
                    
                    <div class=\"info\">
                        <p><strong>Instance ID:</strong> $(hostname)</p>
                        <p><strong>Zone:</strong> ${var.zone}</p>
                        <p><strong>Image:</strong> LAMP Stack (Ubuntu + Apache + MySQL + PHP)</p>
                    </div>
                    <div class=\"metadata\">
                        <h4>Instance Metadata:</h4>
                        <p>Generated: $(date)</p>
                        <p>Internal IP: $(hostname -I | awk '{print \$1}')</p>
                        <p>Public IP: $(curl -s ifconfig.me)</p>
                    </div>
                    
                    <h2>Картинка из bucket</h2>
                    <div class=\"image-container\">
                        <a href=\"https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.website_image.key}\" target=\"_blank\">
                            <img src=\"https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.website_image.key}\" 
                                 alt=\"Image from Yandex Object Storage\">
                        </a>
                        <p>Click on image to open in new tab</p>
                    </div>
                    
                    <div class=\"info\">
                        <h3>Bucket Information:</h3>
                        <p><strong>Bucket Name:</strong> ${yandex_storage_bucket.student_bucket.bucket}</p>
                        <p><strong>File Name:</strong> ${yandex_storage_object.website_image.key}</p>
                        <p><strong>Direct URL:</strong> https://${yandex_storage_bucket.student_bucket.bucket}.storage.yandexcloud.net/${yandex_storage_object.website_image.key}</p>
                    </div>
                </div>
            </body>
            </html>
            EOL"
          - chown -R www-data:www-data /var/www/html/
          - chmod -R 755 /var/www/html/
          - systemctl restart apache2
      EOF
    }
    
    scheduling_policy {
      preemptible = true
    }
  }
  
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  
  allocation_policy {
    zones = [var.zone]
  }
  
  deploy_policy {
    max_unavailable = 1
    max_expansion   = 0
  }
  

 # Настройка проверки состояния
  health_check {
    interval            = 5
    timeout             = 3
    unhealthy_threshold = 5
    healthy_threshold   = 3
    
    http_options {
      port = 80
      path = "/"
    }
  }
  
  depends_on = [
    yandex_iam_service_account.vm-sa,  # Убедитесь, что SA создан первым
    yandex_resourcemanager_folder_iam_member.vm-editor,  # И права назначены
    yandex_storage_object.website_image,
    yandex_vpc_subnet.subnet_a
  ]
}