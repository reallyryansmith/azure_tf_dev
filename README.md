
# Azure Networking and Load Balancer Terraform Modules

This repository defines modular and reusable Terraform configurations for deploying Azure infrastructure components, including networking resources and a web load balancer cluster. It is designed for training, prototyping, and as a foundation for scalable Azure deployments.

## Features

### Networking Module
- Resource Group creation
- Virtual Network (VNet) with configurable address space
- Subnet definitions for web and app tiers
- Route Table with a blackhole route for CIDR filtering (not functional to the build, just testing something different with routes)

### Load Balancer Web Cluster Module
- Public IP address creation
- Azure Load Balancer (Standard SKU)
- Backend pool (3 Ubuntu 22.04 VMs) and load balancing rule
- Health probe for HTTP traffic
- NSG (Network Security Group) rules if applicable

## Repository Structure

```
azure_tf_dev/
├── environments/
│   └── dev/
│       ├── backend.tf
│       ├── dev.auto.tfvars
│       ├── main.tf
│       ├── provider.tf
│       └── variables.tf
├── modules/
│   ├── networking/
│   │   ├── main.tf
│   │   ├── routetable.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── lb_web_cluster/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── README.md
```

## Module Inputs

### Networking Module

| Variable             | Type            | Description                                  |
|----------------------|------------------|----------------------------------------------|
| `resource_group_name`| `string`         | Name of the resource group                   |
| `location`           | `string`         | Azure region                                 |
| `vnet_name`          | `string`         | Name of the virtual network                  |
| `vnet_address_space` | `list(string)`   | CIDR blocks for the VNet                     |
| `route_table_name`   | `string`         | Name of the route table                      |
| `blackhole_prefix`   | `string`         | CIDR to route as blackhole (drop traffic)    |
| `subnets`            | `map(string)`    | Subnet names and CIDR pairs                  |
| `vm_definitions`     | `map(string)`    | VM names and their associated subnet name    |

### Load Balancer Web Cluster Module

| Variable              | Type            | Description                                      |
|-----------------------|------------------|--------------------------------------------------|
| `resource_group_name` | `string`         | Resource group to contain the load balancer     |
| `location`            | `string`         | Azure region                                     |
| `lb_name`             | `string`         | Name of the Azure Load Balancer                 |
| `frontend_subnet_id`  | `string`         | Subnet ID where the load balancer frontend resides |
| `backend_pool_vm_ids` | `list(string)`   | List of VM IDs to include in the backend pool   |

## Usage

1. Navigate to the target environment directory:
   ```bash
   cd environments/dev
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review and apply the plan:
   ```bash
   terraform plan
   terraform apply
   ```

   > The `dev.auto.tfvars` file contains the environment-specific variables.

## Prerequisites

- Terraform v1.3+
- Azure CLI configured and authenticated (`az login`)
- An active Azure subscription

## Notes

- The networking module is a pre-req to the load balancer module.
- All configurations support extension for additional resources such as virtual machines, NSGs, and DNS zones.
- The route table in the networking module includes a blackhole route for simulating traffic filtering scenarios.

## License

MIT License. See [LICENSE](LICENSE) for details.
