# Firewalls are managed by the caller and attached to the nodes via
# var.firewall_ids (see hcloud_server.master / hcloud_server.worker).
# Attaching at creation time ensures new nodes are never exposed unfiltered.
