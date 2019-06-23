# terraform-consul-cluster

This repo demonstrates how to create a Consul cluster running on AWS in 3 AZ zone, using Terraform. 
## Prerequisites

Please install the following components:

1.Terraform (v0.12.1)
2. Create a public key using ssh-keygen in the ubutnu machine and copy and pasted the public key in the git hub setting >new ssh key to have secure communication set between
3. [Docker](https://askubuntu.com/questions/983351/how-to-install-terraform-in-ubuntu).
4. Use the given Ubuntu 16 AMI(ami-07b4156579ea1d7ba) to to quick start the Consul server  
5. You must also have an AWS account. 
6 You will need to set up your AWS credentials. 

```
$ aws configure
AWS Access Key ID [None]: <Enter Access Key ID>
AWS Secret Access Key [None]: <Enter Secret Key>
you will get the option to put the Region 

```
## Creating the Cluster

The cluster is implemented as a [Terraform Module](https://www.terraform.io/docs/modules/index.html). To launch, just run:

```bash
# Initialize terraform first time using
terraform init
>> we will run the above command from the terraform -consul-clsuter dir it will initiating all the plugin and the Modules and all the .tf files

# See what we will create, or do a dry run!
terraform plan

>> It will show what all resources that needs to be configured on the AWS.

terraform apply
>> Create the cluster along with all the resources in the AWS.
```

You will be asked for a region to deploy in, use `us-east-1` should work fine! You can configure the nuances of how the cluster is created in the [`main.tf`](./main.tf) file. Once created, you will see a message like:

```
$ terraform apply
var.region
  Region to deploy the Consul Cluster into

  Enter a value: us-east-1

...

Apply complete! Resources: 20 added, 0 changed, 0 destroyed.

...

Outputs:

consul-dns = consul-lb-1577031185.ap-southeast-1.elb.amazonaws.com
```

Navigate to port 8500 at address provided (eg:-consul-lb-1419246714.us-east-1.elb.amazonaws.com :8500) and you will see the Consul interface. 

## Destroying the Cluster

Bring everything down with:

```
terraform destroy
```

## Project Structure

The module has the following structure:

```
provider.tf               # 
main.tf                   # Cluster definition.
variables.tf              # Basic config.
modules/consul/main.tf    # Main cluster setup.
modules/consul/variables.tf    # Inputs for the module.
modules/consul/outputs.tf # Outputs for the module.
modules/consul/01-vpc.tf  # Network configuration. Defines the VPC, subnets, access etc.
modules/consul/02-consul-node-role.tf  # Defines policies and a role for cluster nodes.
modules/consul/files/consul-node.sh # Setup script for the cluster nodes.

```

## Troubleshooting

**Trying to `plan` or `apply` gives the error `No valid credential sources found for AWS Provider.`**

This means you've not set up your AWS credentials - check the [Prerequisites](#Prerequisites) section of this guide and try again, or check here: https://www.terraform.io/docs/providers/aws/index.html.

**EntityAlreadyExists: Role with name consul-instance-role already exists.**

'Already exists' errors are not uncommon with Terraform, due to the fact that some AWS resource creation can have timing or synchronisation issues. In this case, just try to create again with `terraform apply`.


