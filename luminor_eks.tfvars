/* Environment configuration */
environment="test"

/* VPC configuration */
region="eu-central-1"
vpc_name="luminor_test_vpc"
azs_region=["eu-central-1a", "eu-central-1b", "eu-central-1c"]
vpc_cidr="10.0.0.0/16"
private_subnets=["10.0.1.0/24"]
public_subnets=["10.0.101.0/24"]

/* EKS main configuration */
eks_cluster_config = {
    name="eks-luminor-test"
    eks_ami_id="ami-0e0cef13865e9c872"
    public=true
}

/* EKS workers launching template */
eks_luminor_init_ng = {
    create=true
    name="luminor-test-ng"
    min_size=1
    max_size=3
    desired_size=2
    disk_size=50
    disk_type="gp3"
    disk_throughput=150
    disk_iops=3000
    instance_type="t3.large"
    ec2_ssh_key="fetch3-eu"
}

ec2_instance_profile="arn:aws:iam::127267203009:instance-profile/instance_adm"
ec2_key_pair="fetch3-eu"
ebs_csi_addon_version="v1.17.0-eksbuild.1"