locals {
  kv_name = substr(replace(var.name, "-", ""), 0, 24)
}
