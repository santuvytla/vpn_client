provider "aws" {
  region = "us-east-1"
}


module "vpc" {
  source = "../../modules/vpc"

  name = "Echoworks-dev"

  cidr = "10.51.0.0/16"

  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.51.1.0/24", "10.51.2.0/24", "10.51.3.0/24"]
  public_subnets  = ["10.51.101.0/24", "10.51.102.0/24", "10.51.103.0/24"]


  enable_ipv6 = false

  enable_nat_gateway = true
  single_nat_gateway = true
/*
  public_subnet_tags = {
    Name = "overridden-name-public"
  }
  */

  tags = {
    Owner       = "sravan"
    Environment = "dev"
  }

  vpc_tags = {
    Name = "vpc-echoworks"
  }
  aws_profile = var.aws_profile
  aws_region = var.aws_region
  create_database_subnet_group = true
/*
  enabled                                   = var.enabled
  vpn_gateway_amazon_side_asn               = var.vpn_gateway_amazon_side_asn
  customer_gateway_bgp_asn                  = var.customer_gateway_bgp_asn
  customer_gateway_ip_address               = var.customer_gateway_ip_address
  vpn_connection_static_routes_only         = var.vpn_connection_static_routes_only
  vpn_connection_static_routes_destinations = var.vpn_connection_static_routes_destinations
 
  vpn_connection_tunnel1_inside_cidr        = var.vpn_connection_tunnel1_inside_cidr
  vpn_connection_tunnel2_inside_cidr        = var.vpn_connection_tunnel2_inside_cidr
  vpn_connection_tunnel1_preshared_key      = var.vpn_connection_tunnel1_preshared_key
  vpn_connection_tunnel2_preshared_key      = var.vpn_connection_tunnel2_preshared_key
*/
}
/*
module "db" {
  source = "./modules/rds"

  identifier = "echoworks-dev"

  engine            = "mysql"
  engine_version    = "5.7.19"
  instance_class    = "db.t2.large"
  allocated_storage = 5
  storage_encrypted = false

  # kms_key_id        = "arm:aws:kms:<region>:<accound id>:key/<kms key id>"
  name     = "dev"
  username = "user"
  password = "YourPwdShouldBeLongAndSecure!"
  port     = "3306"
  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"
 db_subnet_group_name = module.vpc.db_subnet_group_name
  multi_az = false
vpc_security_group_ids = [module.vpc.default_security_group_id]
  # disable backups to create DB faster
  backup_retention_period = 0


  enabled_cloudwatch_logs_exports = ["audit", "general"]

  # DB subnet group


  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "echoworks-db-dev"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8"
    },
    {
      name  = "character_set_server"
      value = "utf8"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}
*/

module "ec2" {
  source = "../../modules/ec2"

  aws_profile = var.aws_profile
  aws_region = var.aws_region
  aws_security_group_public_id = module.vpc.default_security_group_id
  aws_subnet_public_id = module.vpc.public_subnets
  dev_ami = var.dev_ami
  dev_instance_type = var.dev_instance_type
  key_name = var.key_name
  public_key_path = var.public_key_path
  #aws_rds_endpoint = module.db.this_db_instance_endpoint
}
module "ad" {
  source = "../../modules/ad"
  admin_password = "echoworks@1234"
  computer_ou = "microsost"
  domain_name = "echoworks.com"
  short_name = "dev"
  subnet_ids = [module.vpc.public_subnets[0],module.vpc.private_subnets[1]]
  vpc_id = module.vpc.vpc_id
}

module "vpn" {
  source = "../../modules/vpn"
  aws_profile = var.aws_profile
  aws_region = var.aws_region
  subnet_id   = module.vpc.public_subnets[0]
  active_directory = module.ad.dir_id
}

