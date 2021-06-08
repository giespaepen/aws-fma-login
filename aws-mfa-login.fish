#!/usr/bin/env fish

function aws-mfa-login -d "Performs a login to AWS with MFA";
  # Check AWS cli
  set AWS_CLI (which aws);

  if test $status -ne 0 
    echo "aws command is not installed; exiting";
    exit 1;
  end

  # Check jq
  # Check AWS cli
  set JQ_CLI (which jq);

  if test $status -ne 0
    echo "jq command is not installed; exiting";
    exit 1;
  end

  # Get the MFA devices, expecting one
  set MFA_DEVICES (aws iam list-mfa-devices --profile default);
  set AWS_USERNAME (echo "$MFA_DEVICES" | jq -r '.MFADevices[0].UserName');
  set AWS_MFA_ARN (echo "$MFA_DEVICES" | jq -r '.MFADevices[0].SerialNumber');

  echo "MFA Login for $AWS_USERNAME";
  echo "Provide MFA code from authenticator:";
  read AWS_MFA_CODE;

  set AWS_CREDENTIALS (aws sts get-session-token --serial-number $AWS_MFA_ARN --token-code $AWS_MFA_CODE --profile default);

  if test $status -eq 0
    # Set the environment
    echo "Environment set. Session expiring on "(echo "$AWS_CREDENTIALS" | jq -r '.Credentials.Expiration');
    echo "Received credentials... Setting them to the environment."
    
    set -Ux AWS_ACCESS_KEY_ID (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.AccessKeyId');
    set -Ux AWS_SECRET_ACCESS_KEY (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SecretAccessKey');
    set -Ux AWS_SESSION_TOKEN (echo "$AWS_CREDENTIALS" | jq -r '.Credentials.SessionToken');
  else
    echo "Something went wrong while setting the credentials..."
  end
end;
