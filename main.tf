# EKS Cluster
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.28"
  subnet_ids      = var.subnet_ids
  vpc_id          = var.vpc_id

  enable_irsa = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

# Node Group (separate submodule)
module "eks_node_group" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "~> 20.0"

  cluster_name = module.eks.cluster_name
  cluster_version = module.eks.cluster_version
  subnet_ids   = var.subnet_ids

  name = "default-node-group"

  instance_types = ["t3.medium"]

  min_size     = 1
  max_size     = 3
  desired_size = 2

  capacity_type = "ON_DEMAND"

  create = true

  tags = {
    Name = "eks-node-group"
  }
}
