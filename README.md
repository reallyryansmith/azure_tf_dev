# Azure Networking Terraform Module

This module provisions a basic Azure networking layout:
- A resource group
- A virtual network
- Two subnets (web and app)
- A route table with a blackhole route

##  Module Inputs

| Variable             | Type            | Description                              |
|----------------------|------------------|------------------------------------------|
| resource_group_name  | string           | Name of the resource group               |
| location             | string           | Azure region                             |
| vnet_name            | string           | Name of the virtual network              |
| vnet_address_space   | list(string)     | VNet address space                       |
| route_table_name     | string           | Name of the route table                  |
| blackhole_prefix     | string           | CIDR to block using blackhole route      |
| subnets              | map(string)      | Subnet names and CIDRs                   |
| vm_definitions       | map(string)      | Map of VM names to subnet keys           |

##  Usage

Each environment (`dev`, `prod`) has its own Terraform setup.

```bash
cd environments/dev
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

Switch to prod:

```bash
cd environments/prod
terraform init
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
```

##  File Structure

```
azure-networking-lab/
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── dev.tfvars
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   └── variables.tf
│   └── prod/
│       ├── backend.tf
│       ├── prod.tfvars
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
└── modules/
    └── networking/
        ├── main.tf
        ├── routetable.tf
        └── variables.tf
```
