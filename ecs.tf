module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "vpc-week19"
  cidr = var.vpc-cidr

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = []

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "vpc-week19"
  }
}

resource "aws_ecs_cluster" "ecs-cluster" {
  name = "ecs-week19"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs-cluster" {
  cluster_name = aws_ecs_cluster.ecs-cluster.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
  }
}

module "ecs-fargate" {
  source = "umotif-public/ecs-fargate/aws"
  version = "~> 6.1.0"

  name_prefix        = "ecs-week19"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets

  cluster_id         = aws_ecs_cluster.ecs-cluster.id

  task_container_image   = "centos"
  task_definition_cpu    = 256
  task_definition_memory = 512

  task_container_port             = 80
  task_container_assign_public_ip = true

load_balanced = false

  target_groups = [
    {
      target_group_name = "tg-week19"
      container_port    = 80
    }
  ]

  health_check = {
    port = "traffic-port"
    path = "/"
  }
}