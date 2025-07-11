resource "hcloud_load_balancer" "web_lb" {
  name               = "${var.cluster_name}-web-lb"
  load_balancer_type = "lb11"
  location           = var.lb_location
  labels = {
    "rke2" = "web"
  }
}

resource "hcloud_load_balancer_network" "web_lb_network_registration" {
  load_balancer_id = hcloud_load_balancer.web_lb.id
  subnet_id        = hcloud_network_subnet.main.id
}

resource "hcloud_load_balancer_target" "web_lb_targets" {

  count            = var.worker_node_count
  type             = "server"
  load_balancer_id = hcloud_load_balancer.web_lb.id
  server_id        = hcloud_server.worker[count.index].id
  use_private_ip   = true
  depends_on = [
    hcloud_load_balancer_network.web_lb_network_registration
  ]
}

resource "hcloud_load_balancer_service" "web_lb_tcp_80_service" {
  load_balancer_id = hcloud_load_balancer.web_lb.id
  protocol         = "tcp"
  listen_port      = 80
  destination_port = 80
  depends_on       = [hcloud_load_balancer_target.web_lb_targets, hcloud_server.worker]
}

resource "hcloud_load_balancer_service" "web_lb_tcp_https_service" {
  load_balancer_id = hcloud_load_balancer.web_lb.id
  protocol         = "tcp"
  listen_port      = 443
  destination_port = 443
  depends_on       = [hcloud_load_balancer_target.web_lb_targets]
}

resource "hcloud_load_balancer_service" "web_lb_service" {
  for_each         = toset(var.additional_web_lb_service_ports)
  load_balancer_id = hcloud_load_balancer.web_lb.id
  protocol         = "tcp"
  listen_port      = tonumber(each.value)
  destination_port = tonumber(each.value)
  depends_on       = [hcloud_load_balancer_target.web_lb_targets]
}
