# Directory service with logging
Terraform AWS module for Directory service directory with cloudwatch logging.
Note that AWS will create a security group automatically.

# Examples
## Minimal example
Assuming a VPC with subnets has been created, for example with [vpc-subnets-internet](https://registry.terraform.io/modules/voquis/vpc-subnets-internet/aws/latest):
```terraform
module "ad" {
  source  = "voquis/directory-service-with-logging/aws"
  version = "0.0.1"

  dns_name = "example.com"
  vpc_id   = module.my_vpc.vpc.id
  subnet_ids = [
    module.my_vpc.subnets[0].id,
    module.my_vpc.subnets[1].id,
  ]
}
```

To access the automatically created security group, use `module.ad.directory_service_directory.security_group_id`.
