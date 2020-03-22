# APIC Parameters
provider "aci" {
  username    = "ansible-test"
  private_key = "${var.aci_private_key}"
  cert_name = "admin"
  url         = "https://10.10.250.55"
  insecure    = true
}

# Create tenant,  no variables
resource "aci_tenant" "terraform_t1" {
  name = "terraform_t1"
}

# Create tenant using variables
resource "aci_tenant" "tenant_resource" {
  name = "${var.tenant_name}"
}
#
# # Create tenants in a list
resource "aci_tenant" "tenant_list" {
  count = 2
  name = "${element(var.tenant_list,count.index)}"
}

# Create a VRF
resource "aci_vrf" "vrf1" {
  tenant_dn = "${aci_tenant.terraform_t1.id}"
  name      = "vrf1"
}
# Create a Bridge Domain
resource "aci_bridge_domain" "bd1" {
  tenant_dn          = "${aci_tenant.terraform_t1.id}"
  relation_fv_rs_ctx = "${aci_vrf.vrf1.name}"
  name               = "bd1"
}
#  Create a subnet on the bridge domain
resource "aci_subnet" "bd_subnet" {
  bridge_domain_dn = "${aci_bridge_domain.bd1.id}"
  name             = "Subnet"
  ip               = "${var.bd1_subnet}"
}
# Create multiple bridge domains
resource "aci_bridge_domain" "bd_list" {
  count = 3
  tenant_dn           = "${aci_tenant.terraform_t1.id}"
  relation_fv_rs_ctx  = "${aci_vrf.vrf1.name}"
  name = "${element(var.bd_list,count.index)}"
}
resource "aci_application_profile" "app_prof" {
  tenant_dn = "${aci_tenant.terraform_t1.id}"
  name      = "MyApp"
}
resource "aci_application_epg" "epg1" {
  application_profile_dn = "${aci_application_profile.app_prof.id}"
  name                   = "epg1"
  relation_fv_rs_bd      = "${aci_bridge_domain.bd1.name}"
  relation_fv_rs_dom_att = ["${var.vmm_domain_dn}"]
}

resource "aci_application_epg" "epg2" {
  application_profile_dn = "${aci_application_profile.app_prof.id}"
  name                   = "epg2"
  relation_fv_rs_bd      = "${aci_bridge_domain.bd_list.2.name}"
  relation_fv_rs_dom_att = ["${var.vmm_domain_dn}"]
}
