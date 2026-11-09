# Optional rke2-canal configuration. Only rendered when an interface regex is
# set, so existing clusters are unchanged by default.
#
# NOTE: the canal chart has no config checksum on its DaemonSet, so changing
# these values only updates the rke2-canal-config ConfigMap. The new interface
# and MTU take effect after `kubectl -n kube-system rollout restart ds/rke2-canal`,
# and pods only pick up a new veth MTU when they are recreated.
resource "kubectl_manifest" "canal_configuration" {
  count      = var.canal_flannel_iface_regex != "" ? 1 : 0
  depends_on = [hcloud_load_balancer_service.management_lb_k8s_service]
  yaml_body = templatefile("${path.module}/templates/values/canal.yaml", {
    IFACE_REGEX = var.canal_flannel_iface_regex
    VETH_MTU    = var.canal_veth_mtu
  })
}
