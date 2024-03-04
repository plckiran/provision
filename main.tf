
#Create resource group and vnet
module "privatecloud" {
	source = "./vmnet"
}

#create NetApp volume
module "fileshare" {
	source = "./Fileshare"

	depends_on = [ module.privatecloud ]
}

#create windows VM
module "sco-web"{
	source		= "./windows_vm"
	depends_on = [ module.privatecloud, module.fileshare]
}

module "sco-app" {
	source = "./windows_vm"
	security_rule_access = "allow"
	security_rule_name = "AppCluster"
	security_rule_direction = "Inbound"
	security_rule_destination_port_range = 4443
	security_rule_priority = 10000
	security_rule_protocol = "tcp"
	depends_on = [ module.privatecloud, module.fileshare]
}






