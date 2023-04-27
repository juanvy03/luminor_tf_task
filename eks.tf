# Create an EKS cluster
module "eks" {
  source       = "terraform-aws-modules/eks/aws"
  version      = "19.10.3"
  cluster_name = var.eks_cluster_config["name"]
  subnet_ids   = module.vpc.private_subnets
  vpc_id       = module.vpc.vpc_id
  node_security_group_id = aws_security_group.allow_internal.id 

  cluster_endpoint_public_access = var.eks_cluster_config["public"]

  tags = merge(local.extra_tags, { "kubernetes.io/cluster/tx24-fg-dev" : "shared" })
  # Configure worker nodes
  eks_managed_node_groups = {
    luminor_init = {
      create_launch_template = var.eks_luminor_init_ng["create"]
      min_size               = var.eks_luminor_init_ng["min_size"]
      max_size               = var.eks_luminor_init_ng["max_size"]
      asg_desired_capacity   = var.eks_luminor_init_ng["desired_size"]

      disk_size       = var.eks_luminor_init_ng["disk_size"]
      disk_type       = var.eks_luminor_init_ng["disk_type"]
      disk_throughput = var.eks_luminor_init_ng["disk_throughput"]
      disk_iops       = var.eks_luminor_init_ng["disk_iops"]

      name                 = var.eks_luminor_init_ng["name"]
      instance_types        = [ var.eks_luminor_init_ng["instance_type"] ]

      ec2_ssh_key = var.eks_luminor_init_ng["ec2_ssh_key"]

      security_groups = [ module.eks.cluster_security_group_id ]

      tags = {
        Terraform   = "true"
        Environment = var.environment
      }
    }
  }


}

data "aws_iam_policy" "ebs_csi_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}

module "iam_iam-assumable-role-with-oidc" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version = "5.16.0"

  create_role                   = true
  role_name                     = "AmazonEKSTFEBSCSIRole-${module.eks.cluster_name}"
  provider_url                  = module.eks.oidc_provider
  role_policy_arns              = [data.aws_iam_policy.ebs_csi_policy.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:kube-system:ebs-csi-controller-sa"]
}

resource "aws_eks_addon" "ebs-csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = var.ebs_csi_addon_version
  service_account_role_arn = module.iam_iam-assumable-role-with-oidc.iam_role_arn
  tags = {
    "eks_addon" = "ebs-csi"
    "terraform" = "true"
  }
}

locals {
  extra_tags = {
    Terraform   = var.environment
    Environment = "dev"
  }
}