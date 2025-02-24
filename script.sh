#!/usr/bin/env bash

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

I_ID=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id)
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
PRIVATE_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/local-ipv4)
SECURITY_GROUPS=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/security-groups)

OS_NAME=$(grep ^NAME= /etc/os-release | cut -d= -f2 | tr -d '"')
OS_VERSION=$(grep ^VERSION= /etc/os-release | cut -d= -f2 | tr -d '"')

USERS=$(grep -E '/(bash|sh)$' /etc/passwd | cut -d: -f1)

FILE="./metadata.txt"
{
  echo "INSTANCE_ID: $INSTANCE_ID"
  echo "PUBLIC_IP: $PUBLIC_IP"
  echo "PRIVATE_IP: $PRIVATE_IP"
  echo "SECURITY_GROUPS: $SECURITY_GROUPS"
  echo "OS_NAME: $OS_NAME"
  echo "OS_VERSION: $OS_VERSION"
  echo "USERS (bash/sh):"
  echo "$USERS"
} > "$FILE"

