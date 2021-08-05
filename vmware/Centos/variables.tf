variable "admin_creds" {
  description = "Credentials for connection to VM's"
  type = map(object({
    vsphere_user     = string
    vsphere_password = string
    vsphere_server   = string
  }))
}

variable "vm_data" {
  description = "Credentials for connection to vsphere"
  type = map(object({
    data_center     = string
    data_store      = string
    compute_cluster = string
    vsphere_network = string
    template_name_relay = string
    template_name_client = string
  }))
}

variable "vm_var_master" {
  description = "vars for creation of relay host"
  type = map(object({
    vm_name = string
    num_cpus = number
    memory = number
    ipv4_address = string
    ipv4_netmask = number
    ipv4_gateway = string
    host_name = string
    domain = string
    disk_label = string
    dns_server_list = list(string)
  }))
}

variable "vm_vars" {
  description = "vars for creation of VM's"
  type = map(object({
    vm_name = string
    num_cpus = number
    memory = number
    ipv4_address = string
    ipv4_netmask = number
    ipv4_gateway = string
    host_name = string
    domain = string
    disk_label = string
    dns_server_list = list(string)
  }))
}

