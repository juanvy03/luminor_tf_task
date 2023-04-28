# Run with 
 terraform plan -var-file luminor_eks.tfvars

# Create users with helm chart in 
juanvy03/luminor_helm_users

# Load EKS config to kubeconfig
aws eks update-kubeconfig --region eu-central-1 --name eks-luminor-test

# Webhook
http://a40ddc466016f41248301b86ef2164c8-1371248771.eu-central-1.elb.amazonaws.com/
secret: ipuswosclihghqcripidfyedeeetmnfctlovocotixpacxnstlappbgtnoytwmgaqzaagmvsltqssdqxsqyvvxrzxpsapduoqhlvmjbcthcpdrqvjkpcngkhxbkfoeom

# Load config
export KUBE_CONFIG_PATH=/Users/juan/.kube/config

# Setup AWS loadbalancer to reach atlantis
eksctl create iamserviceaccount \
  --cluster=eks-luminor-test \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRoleLuminor \
  --attach-policy-arn=arn:aws:iam::127267203009:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve

kubectl annotate serviceaccount -n kube-system aws-load-balancer-controller \eks.amazonaws.com/role-arn=arn:aws:iam::127267203009:role/AmazonEKSLoadBalancerControllerRoleLuminor --overwrite

 helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=eks-luminor-test \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::127267203009:role/AmazonEKSLoadBalancerControllerRoleLuminor"

# Setup ATLANTIS
helm install atlantis runatlantis/atlantis -f .ignore/values.yaml

helm uninstall atlantis runatlantis/atlantis