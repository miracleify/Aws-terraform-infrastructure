# AWS Production Infrastructure with Terraform

Production-oriented AWS infrastructure designed and managed with **Terraform**, with a modular architecture focused on security, scalability, observability, reliability, and repeatable deployments.

This repository demonstrates practical **DevOps / Cloud Engineering** experience building and operating infrastructure for a containerized application running on AWS.

> **Portfolio note:** This repository is a sanitized representation of production infrastructure. Environment-specific credentials, secrets, state files, private configuration, deployment artifacts, and account-specific identifiers are intentionally excluded.

---

## Architecture Overview

The infrastructure provisions and integrates the major components required to run a production-grade containerized application on AWS.

### Core AWS Services

* **Amazon VPC** — isolated network architecture
* **Amazon ECS / Fargate** — container orchestration and application workloads
* **Application Load Balancer** — HTTP/HTTPS traffic distribution
* **Amazon ECR** — private container image registry
* **AWS WAF** — application-layer protection and rate limiting
* **AWS Secrets Manager** — secure application configuration and secrets
* **Amazon CloudWatch** — logs, metrics, dashboards, and alarms
* **Amazon SNS** — operational alert notifications
* **Amazon EventBridge** — event-driven infrastructure monitoring
* **AWS Lambda** — lightweight operational and health-check workloads
* **Amazon Route 53** — DNS management
* **AWS Certificate Manager** — TLS certificate management
* **Amazon RDS** — managed relational database infrastructure
* **Amazon ElastiCache / Redis** — caching infrastructure
* **AWS KMS** — encryption and key management
* **Elastic IP / NAT infrastructure** — controlled outbound connectivity

---

## Infrastructure Architecture

```text
                         Internet
                            │
                            ▼
                     Route 53 / DNS
                            │
                            ▼
                  AWS WAF Web ACL
                            │
                            ▼
                Application Load Balancer
                       ┌────┴────┐
                       │         │
                       ▼         ▼
                    HTTPS      Routing
                       │
                       ▼
                 ECS / Fargate
              ┌────────┼────────┐
              │        │        │
              ▼        ▼        ▼
          Application Services
              │        │
        ┌─────┘        └──────┐
        ▼                     ▼
   RDS / Database          Redis Cache
        │
        ▼
 AWS Secrets Manager

             Application Observability
                       │
          ┌────────────┼────────────┐
          ▼            ▼            ▼
      CloudWatch       SNS       EventBridge
          │                         │
          ▼                         ▼
      Logs/Alarms                Lambda
```

The exact application architecture and environment-specific values are intentionally omitted from this public portfolio version.

---

## Terraform Architecture

The infrastructure is organized into reusable Terraform modules rather than a single monolithic configuration.

```text
.
├── environments/
│   ├── dev/
│   ├── staging/
│   └── production/
│
├── modules/
│   ├── alb/
│   ├── cache/
│   ├── compute/
│   ├── database/
│   ├── dns/
│   ├── monitoring/
│   ├── network/
│   ├── registry/
│   ├── security/
│   └── security_services/
│
├── persistent/
│   ├── eip-production/
│   └── eip-staging/
│
├── backend.tf
├── main.tf
├── providers.tf
├── variables.tf
├── outputs.tf
└── versions.tf
```

### Modular Design

The Terraform modules separate infrastructure responsibilities into logical components:

| Module              | Responsibility                                      |
| ------------------- | --------------------------------------------------- |
| `network`           | VPC, subnets, routing, internet/NAT connectivity    |
| `security`          | Security groups and network access controls         |
| `security_services` | WAF, KMS and Secrets Manager                        |
| `compute`           | ECS cluster, services, IAM, logging and autoscaling |
| `alb`               | Application Load Balancer and target groups         |
| `registry`          | ECR repositories                                    |
| `database`          | Managed database infrastructure                     |
| `cache`             | Redis infrastructure                                |
| `dns`               | Route 53 and DNS resources                          |
| `monitoring`        | CloudWatch, SNS, EventBridge, Lambda and dashboards |

This structure makes infrastructure easier to maintain, review, reuse, and extend.

---

# Environment Strategy

The infrastructure supports separate environments for:

* Development
* Staging
* Production

Environment-specific Terraform variables are intentionally excluded from the public repository.

Example files are provided:

```text
environments/
├── dev/
│   └── terraform.tfvars.example
├── staging/
│   └── terraform.tfvars.example
└── production/
    └── terraform.tfvars.example
```

Real environment values should be supplied locally or through a secure CI/CD system.

---

# Networking

The infrastructure uses a custom AWS VPC architecture with separate networking components for application workloads and controlled outbound access.

Key networking components include:

* VPC
* Public subnets
* Private application subnets
* Internet Gateway
* NAT Gateway
* Route tables
* Application Load Balancer
* Security groups
* Elastic IP infrastructure

Application workloads are designed to run inside private networking boundaries while the load balancer provides controlled inbound access.

---

# Container Infrastructure

Application workloads are deployed using **Amazon ECS with AWS Fargate**.

The Terraform configuration manages:

* ECS cluster
* ECS services
* Task definitions
* IAM roles
* Container logging
* CPU and memory configuration
* Service networking
* Load balancer integration
* Health checks
* Autoscaling configuration

Container images are stored in **Amazon ECR**.

This provides a repeatable deployment model without requiring infrastructure management for individual EC2 container hosts.

---

# Security

Security is treated as an infrastructure concern rather than an application-only concern.

### AWS WAF

The WAF configuration provides application-layer protection including:

* AWS managed rule groups
* IP-based controls
* Rate-based rules
* Authentication endpoint protection
* Custom rules
* CloudWatch integration
* Logging infrastructure

Rate limiting can be applied to sensitive endpoints to reduce abuse and excessive request volume.

### Secrets Management

Application secrets are stored in **AWS Secrets Manager** rather than being hardcoded into Terraform configuration or container definitions.

Terraform references secret resources without exposing the actual secret values in the repository.

### IAM

IAM resources are managed through Terraform to provide controlled permissions for:

* ECS tasks
* ECS execution roles
* CloudWatch logging
* Secrets Manager access
* Lambda functions
* Other AWS service integrations

### Encryption

The infrastructure supports encryption through AWS-managed and customer-managed encryption mechanisms where appropriate, including KMS integration.

---

# Observability & Monitoring

The monitoring layer provides visibility into application and infrastructure health.

### CloudWatch

Configured monitoring includes:

* ECS service metrics
* Application Load Balancer metrics
* Request latency
* Target health
* Resource utilization
* Application logs
* Infrastructure alarms
* Custom application/third-party health metrics

### Alerts

SNS is used for operational notifications.

Critical infrastructure conditions can trigger notification workflows while lower-severity conditions can be handled separately.

### EventBridge

EventBridge is used to react to infrastructure events such as ECS deployment and task/service state changes.

### Lambda Health Checks

Lightweight Lambda functions are used for external dependency health checks where appropriate.

This allows third-party service availability to be monitored independently from the main application workload.

---

# CI/CD Integration

The infrastructure is designed to integrate with a CI/CD workflow.

A typical deployment pipeline can follow:

```text
Developer
    │
    ▼
GitHub
    │
    ▼
CI/CD Pipeline
    │
    ├── Terraform Format
    ├── Terraform Validate
    ├── Security Scanning
    ├── Terraform Plan
    │
    ▼
Approval / Deployment
    │
    ▼
Terraform Apply
    │
    ▼
AWS Infrastructure
```

The infrastructure can be integrated with GitHub Actions or another CI/CD platform to automate validation, planning, and controlled deployment.

---

# Terraform State

Terraform state should be stored remotely rather than committed to Git.

The intended architecture uses:

* Amazon S3 for Terraform state
* DynamoDB-based state locking
* Server-side encryption

Actual state files and environment-specific backend configuration are excluded from the public portfolio where appropriate.

---

# Security & Public Repository Hygiene

This repository intentionally excludes sensitive operational data.

Ignored files include:

```text
*.tfvars
*.tfstate
*.tfplan
.terraform/
*.zip
.env*
AWS credentials
SSH/private keys
```

Public examples are provided where configuration structure is useful:

```text
*.tfvars.example
*.zip.example
```

No production credentials, application secrets, Terraform state, AWS access keys, or private deployment packages should be committed to this repository.

---

# Deployment Workflow

A typical environment deployment follows this pattern:

```bash
terraform init
terraform fmt -recursive
terraform validate
terraform plan
terraform apply
```

Environment-specific variable files should be supplied separately.

For example:

```bash
terraform plan \
  -var-file=environments/staging/terraform.tfvars
```

> Never commit real `.tfvars` files containing credentials, account-specific secrets, or private infrastructure configuration.

---

# Operational Practices Demonstrated

This project demonstrates practical experience with:

* Infrastructure as Code
* Terraform module design
* AWS networking
* ECS/Fargate
* Containerized workloads
* ECR
* Application Load Balancers
* AWS WAF
* IAM
* Secrets Manager
* KMS
* RDS
* Redis
* Route 53
* CloudWatch
* SNS
* EventBridge
* Lambda
* Terraform remote state
* Infrastructure monitoring
* Rate limiting
* Security controls
* Environment separation
* Production troubleshooting
* Deployment automation

---

# Engineering Focus

The infrastructure was designed around several operational principles:

### Security First

Sensitive configuration is separated from source code and managed through dedicated AWS security services.

### Repeatability

Infrastructure is represented as code so environments can be created and changed consistently.

### Observability

Important infrastructure and application dependencies have metrics, logs, and alarms.

### Fault Awareness

External dependencies and ECS service health are monitored independently so failures can be detected quickly.

### Environment Isolation

Development, staging, and production configurations are separated to reduce accidental cross-environment changes.

### Least Privilege

IAM permissions and security groups are designed to restrict access to only the resources required by each workload.

---

# Portfolio Scope

This repository is intended to demonstrate **DevOps and Cloud Engineering implementation**, rather than provide a turnkey deployment of a production application.

Production-specific values have been sanitized or removed.

To reproduce the architecture, provide your own:

* AWS account
* AWS region
* Terraform backend
* DNS domain
* container images
* secrets
* database configuration
* third-party service credentials
* environment variables

---

# Author
**Banor Miracle**

**DevOps / Cloud Engineer**

Specializing in:

* AWS
* Terraform
* Docker
* Kubernetes
* CI/CD
* GitHub Actions
* Infrastructure Automation
* Cloud Security
* Monitoring & Observability

---

## Disclaimer

This repository is a portfolio representation of infrastructure engineering work.

Resource names, identifiers, environment values, credentials, state files, deployment artifacts, and other production-specific information have been removed, replaced, or excluded where appropriate.

The public configuration should **not** be applied directly to a production environment without reviewing and supplying environment-specific values.
