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
MFA_DEVICES=$(aws iam list-mfa-devices --profile default);
AWS_USERNAME=$(jq -r '.MFADevices[0].UserName' <<< "$MFA_DEVICES")

echo "MFA Logout for $AWS_USERNAME";

unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN
unset CODEARTIFACT_AUTH_TOKEN