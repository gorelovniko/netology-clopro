# Создание сервисного аккаунта для Object Storage
resource "yandex_iam_service_account" "bucket-sa" {
  name        = "bucket-service-account"
  description = "Service account for Object Storage"
}

# Назначение роли editor сервисному аккаунту
resource "yandex_resourcemanager_folder_iam_member" "bucket-editor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
}

# Создание статического ключа доступа
resource "yandex_iam_service_account_static_access_key" "bucket-sa-key" {
  service_account_id = yandex_iam_service_account.bucket-sa.id
  description        = "Static access key for Object Storage"
}





# Создание бакета Object Storage
resource "yandex_storage_bucket" "student_bucket" {
  # access_key = yandex_iam_service_account_static_access_key.bucket-sa-key.access_key
  # secret_key = yandex_iam_service_account_static_access_key.bucket-sa-key.secret_key
  
  bucket     = var.bucket_name
  folder_id = var.yc_folder_id
  # acl        = "public-read"
  
  # website {
  #   index_document = "index.html"
  #   error_document = "error.html"
  # }
}



# resource "yandex_storage_bucket_iam_member" "admin_for_sa" {
#   bucket = yandex_storage_bucket.student_bucket.bucket
#   role   = "storage.admin"
#   member = "serviceAccount:${yandex_iam_service_account.bucket-sa.id}"
# }

# 2. Делаем бакет (или конкретные объекты) публичными через IAM.
# Этот блок дает право ВСЕМ пользователям ('allUsers') читать объекты бакета.
# resource "yandex_storage_bucket_iam_member" "public_read" {
#   bucket = yandex_storage_bucket.student_bucket.bucket
#   role   = "storage.viewer"
#   member = "system:allUsers" # Ключевой момент: доступ для всех в интернете
# }

# Загрузка картинки в бакет
resource "yandex_storage_object" "website_image" {
  access_key = yandex_iam_service_account_static_access_key.bucket-sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-sa-key.secret_key
  
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "image.png"
  source = var.image_file_path
  acl    = "public-read"
  
  depends_on = [
    yandex_storage_bucket.student_bucket
  ]
}