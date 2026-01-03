# Infrastructure Templates

## Terraform - AWS Basic Setup

```hcl
# main.tf
terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  backend "s3" {
    bucket = "terraform-state-bucket"
    key    = "app/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

# VPC
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.app_name}-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a", "${var.aws_region}b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = var.environment != "production"
}

# Database
module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 6.0"

  identifier = "${var.app_name}-db"

  engine         = "postgres"
  engine_version = "16"
  instance_class = var.db_instance_class

  allocated_storage     = 20
  max_allocated_storage = 100

  db_name  = var.db_name
  username = var.db_username
  port     = 5432

  vpc_security_group_ids = [module.security_group.security_group_id]
  subnet_ids             = module.vpc.private_subnets

  backup_retention_period = 7
  deletion_protection     = var.environment == "production"
}

# Security Group
module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name   = "${var.app_name}-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]
}
```

```hcl
# variables.tf
variable "app_name" {
  description = "Application name"
  type        = string
}

variable "environment" {
  description = "Environment (development, staging, production)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
}
```

---

## Monitoring - Prometheus Alerts

```yaml
# prometheus/alerts.yml
groups:
  - name: app
    rules:
      - alert: HighErrorRate
        expr: rate(http_requests_total{status=~"5.."}[5m]) > 0.1
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: High error rate detected
          description: "Error rate is {{ $value | humanizePercentage }}"

      - alert: HighLatency
        expr: histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m])) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: High latency detected
          description: "p95 latency is {{ $value | humanizeDuration }}"

      - alert: ServiceDown
        expr: up == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: Service is down
          description: "{{ $labels.instance }} has been down for more than 1 minute"

      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: High memory usage
          description: "Memory usage is {{ $value | humanizePercentage }}"

      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: High CPU usage
          description: "CPU usage is {{ $value }}%"
```

---

## Infrastructure Checklist

### Development Environment
- [ ] docker-compose.yml works
- [ ] All services have health checks
- [ ] .env.example complete
- [ ] Database migrations work
- [ ] Seed data loads

### Staging Environment
- [ ] Mirrors production architecture
- [ ] Uses separate database
- [ ] CI/CD deploys automatically
- [ ] SSL configured

### Production Environment
- [ ] Infrastructure as Code (Terraform/Pulumi)
- [ ] Multi-AZ deployment
- [ ] Auto-scaling configured
- [ ] Backups enabled and tested
- [ ] Monitoring and alerting active
- [ ] Secrets in vault
- [ ] Logging aggregated
- [ ] Runbooks documented
