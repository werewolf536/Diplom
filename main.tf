terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
}

provider "yandex" {
  token     = "XXXXXXXXXXXXXXXXXXXXXXXXXXXX"
  cloud_id  = "b1g13gs23p4nnunvp9m5"
  folder_id = "b1g5in209r6h587vcfl8"
}


resource "yandex_compute_instance" "vm-1" {
  name = "vm-1"
  hostname = "vm-1"
  zone = "ru-central1-a"
  allow_stopping_for_update = false

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8rbj39jquv2080c38n"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
    security_group_ids = [
                           yandex_vpc_security_group.internal-ssh-sg.id,
                           yandex_vpc_security_group.alb-vm-sg.id,
                           yandex_vpc_security_group.zabbix-sg.id,
                           yandex_vpc_security_group.egress-sg.id
                         ]
/*    security_group_ids = [
                            yandex_vpc_security_group.external-ssh-sg.id,
                            yandex_vpc_security_group.internal-ssh-sg.id
                           ] */

    nat       = false
    ip_address = "192.168.10.10"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

  scheduling_policy {
    preemptible = false
  }

}



resource "yandex_compute_instance" "vm-2" {
  name = "vm-2"
  hostname = "vm-2"
  zone = "ru-central1-a"
  allow_stopping_for_update = false

  resources {
    core_fraction = 20
    cores         = 2
    memory        = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8rbj39jquv2080c38n"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.bastion-internal-segment.id
    security_group_ids = [
                           yandex_vpc_security_group.internal-ssh-sg.id,
                           yandex_vpc_security_group.alb-vm-sg.id,
                           yandex_vpc_security_group.zabbix-sg.id,
                           yandex_vpc_security_group.egress-sg.id
                         ]

/*    security_group_ids = [
                            yandex_vpc_security_group.external-ssh-sg.id,
                            yandex_vpc_security_group.internal-ssh-sg.id
                           ] */
    nat       = false
    ip_address = "192.168.10.20"
  }

  metadata = {
    user-data = "${file("./meta.yml")}"
  }

    scheduling_policy {
    preemptible = false
  }
}

