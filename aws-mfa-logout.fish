#!/usr/bin/env fish

function aws-mfa-logout -d "Performs a logout by cleaning all the env vars";
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

  echo "MFA Logout for $AWS_USERNAME";

  set -e 'AWS_SECRET_ACCESS_KEY'
  set -e 'AWS_SESSION_TOKEN'
  set -e 'CODEARTIFACT_AUTH_TOKEN'

  echo "Done..."
end;
