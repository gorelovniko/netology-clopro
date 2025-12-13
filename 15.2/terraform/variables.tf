#=============================== Переменные =================================


#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string
  # default     = ''
 }

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
  # default     = ''
}

#-------------------------== Зона сети по умолчанию ==-----------------------
variable "yc_zone" {
  description = "Yandex Cloud default zone"
  type        = string
  default     = "ru-central1-a"
}

#-----------------------== ID образа ОС по умолчанию ==----------------------
variable "yc_image_id" {
  description = "Yandex Cloud default image"
  default     = "fd8djec02sfvs6t3ojng"
}


# Bucket

variable "bucket_name" {
  description = "Bucket name for images"
  type        = string
  default     = "student-bucket-2025"
}

variable "image_file_path" {
  description = "Path to image file"
  type        = string
  default     = "./science.png"
}

variable "zone" {
  description = "Zone"
  type        = string
  default     = "ru-central1-a"
}

# variable "public_subnet_id" {
#   description = "ID публичной подсети"
# }