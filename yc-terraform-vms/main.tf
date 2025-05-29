# Получение актуального образа Debian 11
data "yandex_compute_image" "debian_image" {
  family = var.vm_image_family
}

# Виртуальная машина zabbix-s
resource "yandex_compute_instance" "zabbix_server_vm" {
  name        = "zabbix-s"
  hostname    = "zabbix-s"
  platform_id = "standard-v3" # Гарантированная доля vCPU, но можно использовать burstable (например, "standard-v3")
  zone        = var.yc_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20 # 20% гарантированной производительности vCPU
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian_image.id
      size     = 10 # Размер диска в ГБ
      type     = "network-ssd"
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    # yandex_vpc_subnet.subnet-1.id
    nat       = true # Для назначения публичного IP-адреса
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }
}

# Виртуальная машина zabbix-a
resource "yandex_compute_instance" "zabbix_agent_vm" {
  name        = "zabbix-a"
  hostname    = "zabbix-a"
  platform_id = "standard-v3" # Гарантированная доля vCPU, но можно использовать burstable (например, "standard-v3")
  zone        = var.yc_zone

  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20 # 20% гарантированной производительности vCPU
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.debian_image.id
      size     = 10 # Размер диска в ГБ
      type     = "network-ssd"
    }
  }
  
  network_interface {
    subnet_id = yandex_vpc_subnet.subnet-1.id
    # yandex_vpc_subnet.subnet-1.id
    nat       = true # Для назначения публичного IP-адреса
  }

  metadata = {
    user-data          = file("./cloud-init.yml")
    serial-port-enable = 1
  }

  scheduling_policy { preemptible = true }
}


resource "yandex_vpc_network" "network-1" {
  name = "network1"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "subnet1"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

resource "local_file" "inventory" {
  content  = <<-XYZ

  [webservers]
  ${yandex_compute_instance.zabbix_server_vm.network_interface.0.nat_ip_address}
  ${yandex_compute_instance.zabbix_agent_vm.network_interface.0.nat_ip_address}
  XYZ
  filename = "./hosts.ini"
} 