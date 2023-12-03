#!/bin/bash

################################################################################
# Delete loadbalancer
################################################################################

helm delete aws-load-balancer-controller -n kube-system

aws cloudformation delete-stack \
    --stack-name eksctl-$CLUSTER_NAME_DESTROY-addon-iamserviceaccount-kube-system-aws-load-balancer-controller

aws elbv2 describe-load-balancers --query "LoadBalancers[?starts_with(LoadBalancerName,'$CLUSTER_NAME_DESTROY')].LoadBalancerArn" --output text | tr "\t" "\n" | xargs -I{} aws elbv2 delete-load-balancer --load-balancer-arn {}

# aws logs delete-log-group --log-group-name $CLUSTER_NAME_DESTROY