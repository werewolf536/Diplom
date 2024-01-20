# Bastion-host
output "bastion_nat" {
  value = yandex_compute_instance.bastion.network_interface.0.nat_ip_address
}
output "bastion" {
  value = yandex_compute_instance.bastion.network_interface.0.ip_address
}

# Web - 1
output "vm-1" {
  value = yandex_compute_instance.vm-1.network_interface.0.ip_address
}

# Web - 2
output "vm-2" {
  value = yandex_compute_instance.vm-2.network_interface.0.ip_address
}

# kibana-server
output "kibana-nat" {
  value = yandex_compute_instance.kibana.network_interface.0.nat_ip_address
}
output "kibana" {
  value = yandex_compute_instance.kibana.network_interface.0.ip_address
}

# zabbix-server
output "zabbix_nat" {
  value = yandex_compute_instance.zabbix-server.network_interface.0.nat_ip_address
}
output "zabbix" {
  value = yandex_compute_instance.zabbix-server.network_interface.0.ip_address
}

# elasticsearch-server
output "elasticsearch" {
  value = yandex_compute_instance.elasticsearch.network_interface.0.ip_address
}

# Balancer
output "load_balancer_pub" {
  value = yandex_alb_load_balancer.alb-lb.listener[0].endpoint[0].address[0].external_ipv4_address
}
