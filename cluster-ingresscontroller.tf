resource "kubectl_manifest" "ingress_configuration" {
  depends_on = [hcloud_load_balancer_service.management_lb_k8s_service]
  yaml_body  = templatefile("${path.module}/templates/values/ingress_controller.yaml", {
    USESECUR = var.enable_nginx_modsecurity_waf,
    USEPROXY = var.enable_nginx_useproxy,
    SERVICES = var.additional_tcp_services
  })
}
