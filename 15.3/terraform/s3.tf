data "external" "current_date" {
  program = ["bash", "-c", "echo '{\"date\": \"'$(date '${var.date_format}')'\"}'"]
}

locals {
  current_date = data.external.current_date.result.date
}

# Создание ключа KMS
resource "yandex_kms_symmetric_key" "bucket-key" {
  name              = "bucket-encryption-key"
  description       = "Ключ для шифрования бакета Object Storage"
  default_algorithm = "AES_256"
  rotation_period   = "8760h" # 1 год
}

# Создание бакета Object Storage
resource "yandex_storage_bucket" "student_bucket" {

  bucket     = "${var.bucket_name}-${local.current_date}"
  folder_id = var.yc_folder_id
  # acl    = "private"

server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.bucket-key.id
        sse_algorithm     = "aws:kms"
      }
    }
  }

  # Опционально: настройка версионирования для дополнительной безопасности
  versioning {
    enabled = true
  }

  # Опционально: политика блокировки удаления
  lifecycle_rule {
    id      = "protect-encrypted-data"
    enabled = true
    
    expiration {
      days = 0
    }

    noncurrent_version_expiration {
      days = 30
    }
  }
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
