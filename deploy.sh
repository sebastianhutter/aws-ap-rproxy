#!/bin/bash

export AWS_PROFILE=privat
export AWS_DEFAULT_REGION=eu-central-1
export S3BUCKETNAME="ars-pugnandi-haproxy-configuration-eu-central-1"

echo "$(date) : render templates"
j2 ap-vpc.yaml.j2 > ap-vpc.cf
j2 ap-ec2.yaml.j2 > ap-ec2.cf
j2 ap-s3.yaml.j2 > ap-s3.cf
echo "$(date) : deploy vpc stack"
aws cloudformation deploy --stack-name ap-proxy-vpc --template-file ap-vpc.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
echo "$(date) : deploy s3 stack"
aws cloudformation deploy --stack-name ap-proxy-s3 --template-file ap-s3.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM
echo "$(date) : copy haproxy.cfg to s3"
aws s3 cp "haproxy.cfg" "s3://${S3BUCKETNAME}/"
echo "$(date) : deploy ec2 stack"
aws cloudformation deploy --stack-name ap-proxy-ec2 --template-file ap-ec2.cf --capabilities CAPABILITY_NAMED_IAM CAPABILITY_IAM

echo "$(date) : get assigned public ip"
publicip=$(aws cloudformation describe-stacks --stack-name ap-proxy-ec2 | jq -r -c '[ .Stacks[0].Outputs[] | select( .OutputKey | contains("PublicEip"))  ][0].OutputValue')
echo "$(date) : public ip is: ${publicip}, make sure to adapt dns records etc"
