locals {

  node_config = {
    small = {
      vm_size    = "standard_d2s_v6"
      node_count = 2
    }

    medium = {
      vm_size    = "standard_d2s_v6"
      node_count = 3
    }

    large = {
      vm_size    = "standard_d2s_v6"
      node_count = 4
    }
  }

  config = local.node_config[var.cluster_size]
}
