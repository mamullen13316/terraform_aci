# # APIC Parameters
# provider "aci" {
#   username    = "ansible-test"
#   private_key = "${var.aci_private_key}"
#   cert_name = "admin"
#   url         = "https://10.10.250.55"
#   insecure    = true
# }
#
# # Create tenant,  no variables
# resource "aci_tenant" "terraform_t1" {
#   name = "terraform_t1"
# }
