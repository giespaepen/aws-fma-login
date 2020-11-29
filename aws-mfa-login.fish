#!/bin/bash

# Check AWS cli
AWS_CLI=(which aws);

if $status -ne 0 
  echo "aws command is not installed; exiting";
  exit 1;
end

# Check jq
# Check AWS cli
JQ_CLI=(which jq);

if $status -ne 0
  echo "jq command is not installed; exiting";
  exit 1;
end

# Get the MFA devices, expecting one
MFA_DEVICES=(aws iam list-mfa-devices);
set AWS_USERNAME (echo "$MFA_DEVICES" | jq -r '.MFADevices[0].UserName');
AWS_MFA_ARN=(echo "$MFA_DEVICES" | jq -r '.MFADevices[0].SerialNumber');

echo "MFA Login for $AWS_USERNAME";
echo "Provide MFA code from authenticator:";
read AWS_MFA_CODE;

AWS_CREDENTIALS=(aws sts get-session-token --serial-number $AWS_MFA_ARN --token-code $AWS_MFA_CODE);
echo "Received credentials... Setting them to the environment."

# Set the environment
set -lx AWS_ACCESS_KEY_ID (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.AccessKeyId');
set -lx AWS_SECRET_ACCESS_KEY (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SecretAccessKey');
set -lx AWS_SESSION_TOKEN (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SessionToken');
echo "Environment set. Session expiring on "(echo "$AWS_CREDENTIALS" | jq -r '.Credentials.Expiration');