
variable "cloud_id" {
  type    = string
  default = ""
}
variable "folder_id" {
  type    = string
  default = ""
}
variable "yc_zone" {
  description = "Зона доступности Yandex Cloud"
  default     = "ru-central1-a"  # или другая зона
}

variable "vm_image_family" {
  description = "Семейство образа для виртуальной машины"
  default     = "debian-11"  # или другой актуальный образ
}

variable "test" {
  type = map(number)
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 20
  }
} 