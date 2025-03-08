#!/bin/bash
export SITE_NAME=$(aws ssm get-parameter --name "/overengineered/site_name" --query "Parameter.Value" --output text)
export SITE_VERSION=$(aws ssm get-parameter --name "/overengineered/site_version" --query "Parameter.Value" --output text)

envsubst < public/index.html.template > public/index.html

