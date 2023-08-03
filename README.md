# kamari-infraestructure
Kamari infraestructure automation project

Tip 

For easy AWS CLI accounts management, configure an AWS CLI profile and name it 'kamari'.

aws configure --profile kamari

The prompt will ask for the secret and access keys, you must provide the Terraform IAM User keys.

Set the region to us-east-1

Set 'kamari' as the default profile through AWS_DEFAULT_PROFILE environment variable.

export AWS_DEFAULT_PROFILE=kamari