#!/bin/bash

cat > ./modules/EKS/helm/todo/aws.yaml <<EOL
container:
  image: $CONTAINER_IMAGE

acm:
  arn: $ACM_ARN

rds:
  host: $HOST
  username: $USERNAME
  password: $PASSWORD
  database: $DATABASE
EOL

