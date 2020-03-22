variable "aci_private_key" {
 default = "admin.key"
 }
variable tenant_name {}
variable tenant_list {type = "list"}
variable bd1_subnet {}
variable bd_list {type = "list"}
variable vmm_domain_dn {}

variable vsphere_user {}
variable vsphere_password {}
variable vsphere_server {}
