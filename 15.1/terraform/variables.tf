# variable "yc_token" {}
# variable "yc_cloud_id" {}
# variable "yc_folder_id" {}
# variable "yc_zone" {
#   default = "ru-central1-a"
# }

#=============================== Переменные =================================

#-------------------------------== ID Облака ==------------------------------
variable "yc_cloud_id" {
  description = "Yandex Cloud ID"
  type        = string

  # Перед git push удалить
  default     = "b1g51144vtfee9bo6o2e"
}

#---------------------== ID папки, где будут создаваться ВМ ==---------------
variable "yc_folder_id" { # 
  description = "Yandex Cloud Folder ID"
  type        = string
  
  # Перед git push удалить
  default     = "b1g08evp9r1vatdqt3nv"
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
  default     = "fd80mrhj8fl2oe87o4e1"
}