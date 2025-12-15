data "external" "current_date" {
  program = ["bash", "-c", "echo '{\"date\": \"'$(date '${var.date_format}')'\"}'"]
}

locals {
  current_date = data.external.current_date.result.date
}

# Создание бакета Object Storage
resource "yandex_storage_bucket" "student_bucket" {

  bucket     = "${var.bucket_name}-${local.current_date}"
  folder_id = var.yc_folder_id

}

resource "yandex_storage_bucket_iam_binding" "bucket-full-access" {
  bucket = yandex_storage_bucket.student_bucket.id
  role   = "storage.editor"  # Можно использовать storage.admin для полного контроля
  
  members = [
    "serviceAccount:${yandex_iam_service_account.bucket-sa.id}",
  ]
}

# Загрузка картинки в бакет
resource "yandex_storage_object" "website_image" {
  bucket = yandex_storage_bucket.student_bucket.bucket
  key    = "image.png"
  source = var.image_file_path
  acl    = "public-read"

  access_key = yandex_iam_service_account_static_access_key.bucket-sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.bucket-sa-key.secret_key

  depends_on = [
    yandex_storage_bucket.student_bucket,
    yandex_storage_bucket_iam_binding.bucket-full-access,
  ]
}