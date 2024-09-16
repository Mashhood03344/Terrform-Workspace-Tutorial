# Terraform Workspaces Tutorial

## Table of Content

1. [Overview](Overview)
2. [What are Terraform Workspaces?](what-are-terraform-workspaces)
3. [Example Scenario](example-scenerio)
4. [Prerequisites](prerequisites)
5. [Terraform Files](terraform-files)
6. [Steps to Perform the Tutorial](steps-to-perform-the-tutorial)
7. [Understanding Workspaces](understanding-workspaces)
8. [Conclusion](conclusion)
9. [Clean Up](clean-up)



## Overview

In this tutorial, we will demonstrate how to use Terraform workspaces to manage multiple environments, such as dev and prod, using the same configuration file but with separate state files. This allows for safe and independent management of different environments, preventing changes in one environment from affecting another.

## What are Terraform Workspaces?

Terraform workspaces allow you to use the same configuration across multiple environments while maintaining separate state files. This is particularly useful when you have similar infrastructure setups for different environments (e.g., development and production), and you want to avoid unintentionally modifying one environment while working on another.

Workspaces in Terraform are somewhat analogous to Git branches, but they aren't exactly the same. In essence, they help you create isolated environments while sharing the same configuration.

## Example Scenario

Let's say you have a development (dev) environment and a production (prod) environment. Both environments use similar resources, and you want to manage them using the same Terraform configuration. However, you don't want changes made in the development environment to affect the production environment, and vice versa.

With Terraform workspaces, you can create separate state files for each environment. This allows you to safely test changes in dev before applying them to prod, without impacting your live production infrastructure.

## Prerequisites

- Terraform installed on your system.
- AWS credentials configured to allow access to your account.

## Terraform Files

1. main.tf

	```bash
	provider "aws" {
	  region = var.region
	}

	locals {
	  instance_name = "${terraform.workspace}-instance"
	}

	resource "aws_instance" "webserver" {
	  ami           = var.ami
	  instance_type = var.instance_type

	  tags = {
	    Name = local.instance_name
	  }
	}
	```
	
This Terraform file defines an AWS EC2 instance resource. The instance_name is dynamically generated based on the current workspace. Each workspace will create a separate instance with a unique name corresponding to the workspace.

2. variables.tf

	```bash
	variable "region" {
	  description = "The name of the AWS region"
	  type        = string
	  default     = "us-east-1"
	}

	variable "ami" {
	  description = "The AMI ID of the Amazon Machine Image that we are using"
	  type        = string
	  default     = "ami-0e86e20dae9224db8"
	}

	variable "instance_type" {
	  description = "The type of EC2 instance that we are using"
	  type        = string
	  default     = "t2.micro"
	}
	```
	
This file defines the variables for the AWS region, AMI, and EC2 instance type.

3. dev.tfvars

	```bash
	region = "us-east-1"
	ami = "ami-0e86e20dae9224db8"
	instance_type = "t2.micro"
	```

The dev.tfvars file contains the variable values for the development environment.

4. prod.tfvars

	```bash
	region = "us-east-2"
	ami = "ami-085f9c64a9b75eed5"
	instance_type = "t2.micro"
	```

The prod.tfvars file contains the variable values for the production environment.

## Steps to Perform the Tutorial

1. Initialize Terraform

Run the following command to initialize Terraform in the directory containing your Terraform configuration files:
	
	terraform init
	
2. Create and Manage Workspaces

You can manage workspaces using the following commands:

- List available workspaces:

	```bash
	terraform workspace list
	```

- Create a new workspace (for example dev or prod):

	```bash
	terraform workspace new <workspace-name>
	```
	
- Select an existing workspace:

	```bash
	terraform workspace select <workspace-name>
	```

- Show the current workspace:

	```bash
	terraform workspace show
	```
	
3. Apply the Configuration

To apply the Terraform configuration to a specific environment (workspace), specify the corresponding variable file (dev.tfvars or prod.tfvars) when running terraform apply.

- For the dev environment:

	```bash
	terraform apply -var-file=dev.tfvars -auto-approve
	```
	
- For the prod environment:

	```bash
	terraform apply -var-file=prod.tfvars -auto-approve
	```
	
Terraform will automatically manage the state files for each workspace in the terraform.tfstate.d directory, ensuring that changes in one environment do not affect the other.

## Understanding Workspaces

Workspaces allow you to use the same configuration file across multiple environments, but with independent state files. When you switch between workspaces, Terraform ensures that the infrastructure in each workspace is managed separately, preventing unintentional changes in critical environments like production.

Here’s how to work with workspaces:

Workspaces act as isolated environments – You can test infrastructure changes in one workspace (e.g., staging) without affecting another (e.g., production).
Unique state files – Each workspace has its own state file, ensuring that changes in one workspace don't overlap with another.
Efficient management – By switching between workspaces, you can easily manage different environments without needing to duplicate configuration files.

## Conclusion

Terraform workspaces are a powerful tool for managing multiple environments using the same configuration. By isolating the state files for each environment, workspaces ensure that you can safely apply changes without risking production stability.

Use the commands and files in this tutorial to set up workspaces for your own infrastructure and manage different environments efficiently. Happy automating!

## Clean Up

To clean up your Terraform infrastructure, follow these steps:

Switch to the workspace where you want to destroy resources. For example, to clean up the dev environment, run:

	terraform workspace select dev
	
Destroy the resources in the selected workspace:

	terraform destroy -auto-approve
	
Switch to the prod workspace to clean up the production environment:

	terraform workspace select prod

Destroy the resources in the prod workspace:

	terraform destroy -auto-approve

By following these steps, you will safely remove all resources from both environments.
