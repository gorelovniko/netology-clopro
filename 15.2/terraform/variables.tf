#=============================== Переменные =================================

#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
 }

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
}

#-------------------------== Зона сети по умолчанию ==-----------------------
# variable "yc_zone" {
#   description = "Yandex Cloud default zone"
#   type        = string
#   default     = "ru-central1-a"
# }

#-----------------------== ID образа ОС по умолчанию ==----------------------
variable "yc_image_id" {
  description = "Yandex Cloud default image"
  default     = "fd8djec02sfvs6t3ojng"
}


# Bucket

variable "bucket_name" {
  description = "Bucket name for images"
  type        = string
}

variable "image_file_path" {
  description = "Path to image file"
  type        = string
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "ru-central1-a"
}

variable "date_format" {
  description = "Формат даты"
  type        = string
  default     = "+%Y-%m-%d"
}