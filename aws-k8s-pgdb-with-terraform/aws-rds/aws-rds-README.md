# What is this?
Terraform scripts to create a minimal Postgres RDS database for the tutorial.

Needs environment variables for some secrets, as noted in the variables.tf file.

For a good understanding of how this code works, please look at [this Postgres setup example](https://github.com/terraform-aws-modules/terraform-aws-rds/tree/master/examples/complete-postgres) on the [Terraform AWS provider](https://www.terraform.io/docs/providers/aws/) github page.

# IMPORTANT

The code presented here is quite minimal; if you still want to use this code to create an RDS instance that can talk to your [EKS k8s cluster](/aws-k8s-pgdb-with-terraform/aws-kubernetes/aws-k8s-README.md), you will need to replace hard-coded subnet and Security group strings in [db.tf](/aws-k8s-pgdb-with-terraform/aws-rds/db.tf) with your EKS cluster's information.

You will need to install Terraform and expose environment variables (listed in the [variables.tf](variables.tf) file on your Terraform host machine to get the examples to work.