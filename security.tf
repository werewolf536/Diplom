# External ssh

resource "yandex_vpc_security_group" "external-ssh-sg" {
  name                = "external-ssh-sg"
  description         = "external ssh"
  network_id          = yandex_vpc_network.bastion-network.id

  ingress {
    description       = "Input TCP 22"
    protocol          = "TCP"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 22
  }

  ingress {
    description       = "Input TCP SSH (internal-ssh-sg) 22 port"
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.internal-ssh-sg.id
    port              = 22
  }

  egress {
    description       = "Output all"
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }

  egress {
    description       = "Output TCP 22 local SSH (internal-ssh-sg)"
    protocol          = "TCP"
    port              = 22
    security_group_id = yandex_vpc_security_group.internal-ssh-sg.id
  }

}

# Internal ssh

resource "yandex_vpc_security_group" "internal-ssh-sg" {

  name                = "internal-ssh-sg"
  description         = "Internal ssh"
  network_id          = yandex_vpc_network.bastion-network.id

  ingress {
    description       = "Input TCP 22"
    protocol          = "TCP"
    v4_cidr_blocks    = ["192.168.10.0/24"]
    port              = 22
  }

  egress {
    description       = "Output TCP 22 port"
    v4_cidr_blocks    = ["192.168.10.0/24"]
    protocol          = "TCP"
    port              = 22
  }

  egress {
    description       = "Output 22 port"
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }

}

# Balancer Input

resource "yandex_vpc_security_group" "alb-sg" {
  name                = "alb-sg"
  network_id          = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 80
  }

  ingress {
    description       = "healthchecks"
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
    port              = 30080
  }
}

# Balancer into Web-servers

resource "yandex_vpc_security_group" "alb-vm-sg" {
  name                = "alb-vm-sg"
  network_id          = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.alb-sg.id
    port              = 80
  }

  ingress {
    description       = "ssh"
    protocol          = "TCP"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 22
  }

}

# All Output

resource "yandex_vpc_security_group" "egress-sg" {
  name                = "egress-sg"
  network_id          = yandex_vpc_network.bastion-network.id

  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
}

# Zabbix agent SG

resource "yandex_vpc_security_group" "zabbix-sg" {
  name                = "zabbix-sg"
  network_id          = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.zabbix-server-sg.id
    from_port         = 10050
    to_port           = 10051
  }

  egress {
    protocol          = "TCP"
    security_group_id = yandex_vpc_security_group.zabbix-server-sg.id
    from_port         = 10050
    to_port           = 10051
  }
}

# Zabbix server SG

resource "yandex_vpc_security_group" "zabbix-server-sg" {
  name        = "zabbix-server-sg"
  network_id  = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    port              = 80
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = yandex_vpc_subnet.bastion-external-segment.v4_cidr_blocks
    from_port         = 10050
    to_port           = 10052
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = yandex_vpc_subnet.bastion-internal-segment.v4_cidr_blocks
    from_port         = 10050
    to_port           = 10051
  }

}

#Elasticsearch server security group

resource "yandex_vpc_security_group" "elastic-sg" {
  name        = "elastic-sg"
  network_id  = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.bastion-internal-segment.v4_cidr_blocks
    port = 9200
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.bastion-external-segment.v4_cidr_blocks
    port = 9200
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.bastion-internal-segment.v4_cidr_blocks
    port = 9300
  }

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = yandex_vpc_subnet.bastion-external-segment.v4_cidr_blocks
    port = 9300
  }

}

#Kibana server security group

resource "yandex_vpc_security_group" "kibana-sg" {
  name        = "kibana-sg"
  network_id  = yandex_vpc_network.bastion-network.id

  ingress {
    protocol          = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port = 5601
  }

}
