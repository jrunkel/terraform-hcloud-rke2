resource "kubectl_manifest" "ingress_configuration" {
  depends_on = [hcloud_load_balancer_service.management_lb_k8s_service]
  count      = var.enable_nginx_modsecurity_waf ? 1 : 0
  yaml_body  = file("${path.module}/templates/values/ingress_controller.yaml")
}

resource "kubectl_manifest" "ingress_use_proxy" {
  depends_on = [hcloud_load_balancer_service.web_lb_k8s_service]
  count      = var.enable_nginx_useproxy ? 1 : 0
  yaml_body  = file("${path.module}/templates/values/ingress_controller_proxy.yaml")
}
