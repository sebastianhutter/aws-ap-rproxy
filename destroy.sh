#!/bin/bash


export AWS_PROFILE=privat
export AWS_DEFAULT_REGION=eu-central-1


echo "$(date) : delete ec2 stack"
aws cloudformation delete-stack --stack-name ap-proxy-ec2
aws cloudformation wait stack-delete-complete --stack-name ap-proxy-ec2

echo "$(date) : delete vpc stack"
aws cloudformation delete-stack --stack-name ap-proxy-vpc
aws cloudformation wait stack-delete-complete --stack-name ap-proxy-vpc

echo "$(date) : please remove all files from the s3 bucket and remove the stack manually"