#!/bin/bash

# simple update script for haproxy config
export AWS_PROFILE=privat
export AWS_DEFAULT_REGION=eu-central-1
export SSHKEY="${HOME}/.ssh/id_rsa.aws"

publicip=$(aws cloudformation describe-stacks --stack-name ap-proxy-ec2 | jq -r -c '[ .Stacks[0].Outputs[] | select( .OutputKey | contains("PublicEip"))  ][0].OutputValue')

ssh -i ${SSHKEY} ec2-user@${publicip} /usr/local/bin/update.sh