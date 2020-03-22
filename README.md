# terraform_aci  

This Terraform plan demonstrates creation of the following in ACI:
1. Tenant
2. VRF
3. Bridge Domain
4. Bridge Domain Subnet
5. Application Profile
6. Endpoint Groups
  
In addition, a CentOS 7 VM is created in VMware and the vNIC on the VM is configured with the port group which maps to the ACI Endpoint Group (EPG).  A CentOS 7 template must be present in your VMware environment for creation of the virtual machine. 
