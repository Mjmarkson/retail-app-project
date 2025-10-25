# Deploying a Containerized Retail Application to Amazon EKS

## Introduction

This report documents the complete process of deploying a containerized retail application to Amazon Elastic Kubernetes Service (EKS) using Terraform for Infrastructure as Code (IaC) and integrating it with the AWS Application Load Balancer (ALB) Ingress Controller for secure external access.

### Project Highlights

- Infrastructure provisioning with Terraform
- EKS cluster setup and application deployment
- Ingress routing with ALB and ACM-managed SSL certificates
- CI/CD automation for Terraform using GitHub Actions
- DNS integration with Namecheap for custom domain routing

---

## 1. Infrastructure Provisioning with Terraform

Infrastructure was provisioned using Terraform, following a resource-based file structure instead of modules. Each AWS resource was defined in a dedicated file for clarity and maintainability:

| File | Purpose |
|------|---------|
| `vpc.tf` | Defines the VPC and its CIDR block |
| `subnets.tf` | Creates public and private subnets across availability zones |
| `igw.tf` | Configures Internet Gateway for public subnet access |
| `routes.tf` | Sets up route tables and associations for traffic flow |
| `eks.tf` | Provisions the EKS cluster and worker node groups |
| `providers.tf` | Declares AWS provider configuration |
| `locals.tf` | Defines reusable variables and naming conventions |

Additionally, a remote backend was configured to store the Terraform state file securely. This ensured collaboration, state consistency, and disaster recovery capabilities.

---

## 2. EKS Cluster Setup

The Amazon EKS cluster was created using the `eks.tf` definition. Key configurations included:

- Worker node groups with auto-scaling
- IAM roles and policies for EKS and worker nodes
- Security groups for Kubernetes communication

---

## 3. Application Deployment

The retail application (frontend UI and backend API) was containerized and deployed to the EKS cluster.

**Kubernetes Manifests:**

- **Namespace:** `retail-dev`
- **Deployments:** Separate deployments for `ui` and `api` services
- **Services:** Exposed via ClusterIP for internal communication

---

## 4. Ingress and ALB Integration

The AWS Load Balancer Controller was installed to manage ingress traffic. The Ingress resource was annotated to:

- Use an internet-facing ALB
- Configure listeners on HTTP (80) and HTTPS (443)
- Attach an ACM-issued SSL certificate
- Define health check paths (`/health`)

---

## 5. CI/CD Pipeline for Terraform

A GitHub Actions pipeline was configured to automate Terraform operations. The workflow:

### On Push to Feature Branch:
- Runs `terraform fmt` to enforce code formatting
- Runs `terraform validate` to check syntax and indentation
- Executes `terraform plan` to detect changes

### On Merge to Main:
- Executes `terraform apply` to provision/update infrastructure

This ensured safe, automated infrastructure deployments while maintaining high-quality Terraform code practices.

---

## 6. IAM User Integration with RBAC

I provisioned an IAM user in AWS and integrated it with the Kubernetes cluster through RBAC (Role-Based Access Control). Using this setup, I bound the user's AWS identity to a Kubernetes role, assigning permissions that allow the user to read, list, and describe cluster resources. This ensures secure, fine-grained access control while maintaining limited privilege.

---

## Conclusion

This project successfully demonstrated the deployment of a retail application on AWS EKS using Terraform and GitHub Actions. 

### Key Achievements:

✅ Infrastructure as Code with Terraform using a file-per-resource approach  
✅ Secure, scalable application hosting on EKS  
✅ Automated CI/CD pipeline for infrastructure with GitHub Actions  
✅ RBAC integration for IAM user access control  

This deployment approach is production-ready and can be extended for scaling, monitoring, and further automation.

---

## Technologies Used

![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-232F3E?style=for-the-badge&logo=amazon-aws&logoColor=white)
![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)
![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)
