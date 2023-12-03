#!/bin/bash

################################################################################
# Configure
################################################################################

aws eks update-kubeconfig --region us-west-2 --name $CLUSTER_NAME

################################################################################
# AWS K8S loadbalancer pre-requirement
################################################################################

eksctl utils associate-iam-oidc-provider \
    --region us-west-2 \
    --cluster $CLUSTER_NAME \
    --approve

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy-$CLUSTER_NAME \
    --policy-document file://resources/iam-policy.json

eksctl delete iamserviceaccount --name aws-load-balancer-controller --cluster $CLUSTER_NAME

eksctl create iamserviceaccount \
    --cluster=$CLUSTER_NAME \
    --namespace=kube-system \
    --name=aws-load-balancer-controller \
    --attach-policy-arn=arn:aws:iam::492804330065:policy/AWSLoadBalancerControllerIAMPolicy-$CLUSTER_NAME \
    --override-existing-serviceaccounts \
    --region us-west-2 \
    --approve

################################################################################
# AWS K8S loadbalancer 
################################################################################

helm repo add eks https://aws.github.io/eks-charts

helm repo update eks

kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
            -n kube-system \
            --set clusterName=$CLUSTER_NAME \
            --set serviceAccount.create=false \
            --set serviceAccount.name=aws-load-balancer-controller

# wait for load balancer controller deploys completely in k8s
sleep 60

################################################################################
# Metric server for K8S HPA
################################################################################

kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

################################################################################
# Helm todo app
################################################################################

helm install todo-app ./helm/todo

# wait for load balancer creates completely
sleep 120


################################################################################
# AWS EKS cloudwatch
################################################################################

kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cloudwatch-namespace.yaml

kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-serviceaccount.yaml

kubectl apply -f ./resources/cwagent-configmap.yaml

kubectl apply -f https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/cwagent/cwagent-daemonset.yaml