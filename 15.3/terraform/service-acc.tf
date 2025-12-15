#--------------------------backet-sa
# Создание сервисного аккаунта для Object Storage
resource "yandex_iam_service_account" "bucket-sa" {
  name        = "bucket-service-account"
  description = "Service account for Object Storage"
}

# Назначение роли editor сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "bucket-sa-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "Static access key for Object Storage"
}

#--------------------------vm-editor

# Создание сервисного аккаунта для ВМ
resource "yandex_iam_service_account" "vm-sa" {
  name        = "vm-service-account"
  description = "Service account for VMs"
}

# Назначение ролей сервисному аккаунту ВМ
resource "yandex_resourcemanager_folder_iam_member" "vm-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}

resource "yandex_resourcemanager_folder_iam_member" "vpc-user" {
  folder_id = var.yc_folder_id
  role      = "vpc.user"
  member    = "serviceAccount:${yandex_iam_service_account.vm-sa.id}"
}
