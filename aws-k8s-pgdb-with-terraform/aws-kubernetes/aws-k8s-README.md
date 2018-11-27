# EKS Getting Started Guide Configuration

This is the full configuration from https://www.terraform.io/docs/providers/aws/guides/eks-getting-started.html

See that guide for additional information.

NOTE: This full configuration utilizes the [Terraform http provider](https://www.terraform.io/docs/providers/http/index.html) to call out to icanhazip.com to determine your local workstation external IP for easily configuring EC2 Security Group access to the Kubernetes master servers. Feel free to replace this as necessary.

You will need to [install Terraform](https://www.terraform.io/intro/getting-started/install.html) and expose environment variables (listed in the [variables.tf](variables.tf) file on your Terraform host machine to get the examples to work.

_Quick tip_: The AWS IAM user used to spin up the EKS cluster needs several permissions, as documented [here](https://github.com/awsdocs/amazon-eks-user-guide/blob/master/doc_source/EKS_IAM_user_policies.md) and [here](https://github.com/WesleyCharlesBlake/terraform-aws-eks/pull/6). Also, you may need to wait up to 30 minutes before the policies become active in AWS.
