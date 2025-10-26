#!/bin/bash

echo "=== Step 1: Verify Cluster Access ==="
aws eks update-kubeconfig --region eu-west-2 --name staging-altsch_project
kubectl get nodes

echo -e "\n=== Step 2: Deploy Retail Store Application ==="
kubectl apply -f https://github.com/aws-containers/retail-store-sample-app/releases/latest/download/kubernetes.yaml

echo -e "\n=== Step 3: Wait for Deployments ==="
kubectl wait --for=condition=available deployments --all --timeout=10m

echo -e "\n=== Step 4: Check Pods Status ==="
kubectl get pods

echo -e "\n=== Step 5: Check Services ==="
kubectl get svc

echo -e "\n=== Step 6: Get UI Service Details ==="
kubectl get svc ui

echo -e "\n=== Step 7: Apply RBAC Configuration ==="
cd k8s-manifest/
kubectl apply -f viewer-cluster-role.yaml
kubectl apply -f viewer-cluster-role-binding.yaml
cd ..

echo -e "\n=== Step 8: Verify RBAC ==="
kubectl get clusterrole viewer-readonly
kubectl get clusterrolebinding viewer-readonly-binding

echo -e "\n=== Step 9: Git Operations ==="
git add .
git commit -m "Complete Project Bedrock deployment - retail store app on EKS"
git push origin main

echo -e "\n=== Deployment Complete! ==="
echo "Application URL (if LoadBalancer):"
kubectl get svc ui -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'
echo ""
