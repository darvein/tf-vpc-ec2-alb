# VCP and EC2 Provisioning with Terraform

This project deploy a set of AWS Resources to get a simple web server running behind a load balancer.

## Setup and configuration

Before deploying the infrastructure resources you can tune or modify it by editing the file `.env` which contains variables that are later passed to Terraform.

You can also leave the `.env` file as it is which already contains default valules.

Once you are done with your custom configuration make sure to provide the needed AWS Credentials either by setting up your `~/.aws/credentials`  file, passing the `export AWS_PROFILE=<profile name>` environment variable, or just simple passing the AWS Keys and Secret keys via environment variables, more information: https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-files.html 

## What is going to be deployed:

If you lave the configuration by default in `.env`, then you will get:

- 1 S3 Bucket where the infrastructure state is going to be stored
- 1 VPC with 2 public subnets and 1 private subnet
- 3 EC2 Instances. 2 exposed to the world on port 80 and 1 internal with quake arena ports open internally.
- 1 Application load balancer that will serve the 2 public EC2 instances

## Pre-deployment

Before deploying the whole stack, you will need a place to store the infrastructure state, for this purpose just run:

```
export $(cat .env | xargs)

cd remote-state
terraform init
terraform apply
cd ../
```
Then you will have deployed an AWS S3 bucket where the infrastructure state is going to be stored for Terraform operations.

## Deployment of AWS Resources

Now you have everything in place, you can just run:
```
export $(cat .env | xargs)

terraform init
terraform plan
terraform apply
```
Once finished you will have all the infrastructure deployed. You will notice as part of the output you will get some relevant information needed like the LB Endpoint, the subnets CIDRs, the ssh private key, etc.

If you later need to check again the information output you can just run:

`terraform output`

## Clean up

If you need to clean up or destroy everything, you can run:

`terraform destroy`

## Limitations and considerations

- No IPv6 Support
- No NACLs custom configuration in VPC
- Due to TF limitation, the Remote State S3 bucket used for TF Backend needs to be manually updated if you want to change it in `backend.tf` or you can just leave it as default as it is now. Reference: https://github.com/hashicorp/terraform/issues/13022
- Due to security concerns, while cleaning up you will have to manualy remove the S3 Bucket `tf-remotestate-s3demo` which holds the infrastructure information.
