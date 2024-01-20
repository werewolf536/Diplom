resource "yandex_compute_snapshot_schedule" "snapshot" {
  name = "snapshot"

  schedule_policy {
    expression = "0 01 * * *"
  }

  snapshot_count = 7

  disk_ids = [
    "${yandex_compute_instance.bastion.boot_disk.0.disk_id}",
    "${yandex_compute_instance.vm-1.boot_disk.0.disk_id}",
    "${yandex_compute_instance.vm-2.boot_disk.0.disk_id}",
    "${yandex_compute_instance.zabbix-server.boot_disk.0.disk_id}",
    "${yandex_compute_instance.elasticsearch.boot_disk.0.disk_id}",
    "${yandex_compute_instance.kibana.boot_disk.0.disk_id}", ]
}

