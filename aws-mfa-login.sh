#!/bin/bash

# Check AWS cli
AWS_CLI=`which aws`

if [ $? -ne 0 ]; then
  echo "aws command is not installed; exiting"
  exit 1
fi

# Check jq
# Check AWS cli
JQ_CLI=`which jq`

if [ $? -ne 0 ]; then
  echo "jq command is not installed; exiting"
  exit 1
fi

# Get the MFA devices, expecting one
MFA_DEVICES=$(aws iam list-mfa-devices);
AWS_USERNAME=$(jq -r '.MFADevices[0].UserName' <<< "$MFA_DEVICES")
AWS_MFA_ARN=$(jq -r '.MFADevices[0].SerialNumber' <<< "$MFA_DEVICES")

echo "MFA Login for $AWS_USERNAME";
echo "Provide MFA code from authenticator:";
read AWS_MFA_CODE;

AWS_CREDENTIALS=$(aws sts get-session-token --serial-number $AWS_MFA_ARN --token-code $AWS_MFA_CODE);
echo "Received credentials... Setting them to the environment."

# Set the environment
export AWS_ACCESS_KEY_ID=$(jq -r '.Credentials.AccessKeyId' <<< "$AWS_CREDENTIALS");
export AWS_SECRET_ACCESS_KEY=$(jq -r '.Credentials.SecretAccessKey' <<< "$AWS_CREDENTIALS");
export AWS_SESSION_TOKEN=$(jq -r '.Credentials.SessionToken' <<< "$AWS_CREDENTIALS");
echo "Environment set. Session expiring on $(jq -r '.Credentials.Expiration' <<< "$AWS_CREDENTIALS")";