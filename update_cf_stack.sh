#!/usr/bin/env bash

CF_BUCKET_URL="https://s3.amazonaws.com/bootstrap-awss3cloudformationbucket-19qromfd235z9/master"

STACK_NAME="bootstrap"
CF_TEMPLATE="$STACK_NAME.yml"
echo -e "\nDeploying CF template $CF_BUCKET_URL/$CF_TEMPLATE"
UPDATE_CMD="aws cloudformation update-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-url $CF_BUCKET_URL/$CF_TEMPLATE"
# Handle message that shouldn't be an error, https://github.com/hashicorp/terraform/issues/5653
message=$($UPDATE_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"No updates are to be performed".* ]]; then
  echo -e "\nNo stack changes detected. An update is not required."
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo $message
fi

STACK_NAME="essentials"
CF_TEMPLATE="$STACK_NAME.yml"
echo -e "\nDeploying CF template $CF_BUCKET_URL/$CF_TEMPLATE"
UPDATE_CMD="aws cloudformation update-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-url $CF_BUCKET_URL/$CF_TEMPLATE \
--parameters \
ParameterKey=FhcrcVpnCidrip,ParameterValue=\"$FhcrcVpnCidrip\" \
ParameterKey=OperatorEmail,ParameterValue=\"$OperatorEmail\""
message=$($UPDATE_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"No updates are to be performed".* ]]; then
  echo -e "\nNo stack changes detected. An update is not required."
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo $message
fi

STACK_NAME="vpc"
CF_TEMPLATE="$STACK_NAME.yml"
echo -e "\nDeploying CF template $CF_BUCKET_URL/$CF_TEMPLATE"
UPDATE_CMD="aws cloudformation update-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-url $CF_BUCKET_URL/$CF_TEMPLATE \
--parameters \
ParameterKey=VpcSubnetPrefix,ParameterValue=\"$VpcSubnetPrefix\""
message=$($UPDATE_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"No updates are to be performed".* ]]; then
  echo -e "\nNo stack changes detected. An update is not required."
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo $message
fi

STACK_NAME="accounts"
CF_TEMPLATE="$STACK_NAME.yml"
echo -e "\nDeploying CF template cf_templates/$CF_TEMPLATE"
UPDATE_CMD="aws cloudformation update-stack \
--stack-name $STACK_NAME \
--capabilities CAPABILITY_NAMED_IAM \
--notification-arns $CloudformationNotifyLambdaTopicArn \
--template-body file://cf_templates/$CF_TEMPLATE \
--parameters \
ParameterKey=InitNewUserPassword,ParameterValue=\"$InitNewUserPassword\""
message=$($UPDATE_CMD 2>&1 1>/dev/null)
error_code=$(echo $?)
if [[ $error_code -ne 0 && $message =~ .*"No updates are to be performed".* ]]; then
  echo -e "\nNo stack changes detected. An update is not required."
  error_code=0
elif [[ $error_code -ne 0 ]]; then
  echo $message
  exit $error_code
else
  echo $message
fi

