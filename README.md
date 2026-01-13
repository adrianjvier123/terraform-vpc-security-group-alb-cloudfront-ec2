# terraform-vpc-security-group-alb-cloudfront-ec2

Terraform AWS Well-Architected Lab

VPC · Security Groups · ALB · CloudFront · EC2 (Private)

📌 Overview

This repository contains a hands-on Terraform laboratory designed to demonstrate how to build a secure, scalable, and cost-aware AWS architecture following the AWS Well-Architected Framework.

The lab provisions an end-to-end infrastructure using Terraform, exposing how CloudFront can be used as a CDN in front of an Application Load Balancer (ALB) to securely deliver content from private EC2 instances running inside a VPC.

🏗️ Architecture Highlights

The infrastructure includes:

VPC with public and private subnets

Private EC2 instances (no direct internet access)

Application Load Balancer (ALB) deployed in public subnets

Security Groups following least-privilege principles

CloudFront Distribution using the ALB as origin

End-to-end traffic flow:
CloudFront → ALB → Private EC2

This setup demonstrates how to expose applications securely without making compute resources publicly accessible.

🎯 Learning Objectives

This lab helps you understand how to:

Design a Well-Architected network topology

Use Terraform to define reusable and maintainable infrastructure

Secure workloads by keeping EC2 instances private

Integrate CloudFront with an ALB to:

Improve performance using edge caching

Add an additional security layer

Enable global content delivery

Apply least privilege and defense-in-depth using Security Groups

Align infrastructure decisions with the Well-Architected pillars

🧱 Well-Architected Framework Alignment

This project aligns with the following AWS Well-Architected pillars:

Security: Private EC2, controlled ingress/egress, CloudFront as the public entry point

Reliability: ALB handling traffic distribution and health checks

Performance Efficiency: CloudFront edge caching and optimized traffic flow

Operational Excellence: Infrastructure as Code using Terraform

Cost Optimization: Avoids unnecessary public resources and enables CDN caching

🧪 Intended Audience

Cloud Engineers

DevOps Engineers

Solutions Architects

Anyone learning Terraform + AWS best practices

This is a learning-focused lab, not a production-ready module, designed to illustrate architectural patterns and trade-offs.

📂 Terraform Resources Covered

terraform-vpc

terraform-security-group

terraform-alb

terraform-cloudfront

terraform-ec2

⚠️ Disclaimer

This repository is intended for educational purposes only.
Review and adapt configurations before using in production environments.
