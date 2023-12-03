################################################################################
# EKS cluster
################################################################################

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "cluster_role" {
  name               = var.eks-cluster_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}
resource "aws_iam_role_policy_attachment" "role-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster_role.name
}
resource "aws_iam_role_policy_attachment" "role-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster_role.name
}

resource "aws_eks_cluster" "tu_cluster" {
  name     = var.eks-cluster_name
  role_arn = aws_iam_role.cluster_role.arn

  vpc_config {
    subnet_ids             = var.private_subnets_id
    endpoint_public_access = true
    public_access_cidrs    = ["0.0.0.0/0"]
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.role-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.role-AmazonEKSVPCResourceController,
  ]
}

################################################################################
# EKS node-group
################################################################################

resource "aws_iam_role" "tu_node_role" {
  name = var.eks-node_role_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tu_node_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.tu_node_role.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tu_node_role.name
}
resource "aws_iam_role_policy_attachment" "example-CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.tu_node_role.name
}

resource "aws_eks_node_group" "tu_nodes" {
  cluster_name    = aws_eks_cluster.tu_cluster.name
  node_group_name = var.eks-node_group_name
  node_role_arn   = aws_iam_role.tu_node_role.arn
  subnet_ids      = var.private_subnets_id
  instance_types  = [var.eks-instance_types]
  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.example-CloudWatchAgentServerPolicy
  ]
}

################################################################################
# After all
################################################################################

resource "null_resource" "build-aws-loadbalancer-controller" {
  provisioner "local-exec" {
    when        = create
    command     = "./scripts/build.sh"
    interpreter = ["sh"]
    working_dir = path.module
    environment = {
      CLUSTER_NAME = var.eks-cluster_name
    }
  }

  triggers = {
    cluster_name = var.eks-cluster_name
  }

  provisioner "local-exec" {
    when        = destroy
    command     = "./scripts/destroy.sh"
    interpreter = ["sh"]
    working_dir = path.module
    environment = {
      CLUSTER_NAME_DESTROY = self.triggers.cluster_name
    }
  }
  depends_on = [aws_eks_cluster.tu_cluster, aws_eks_node_group.tu_nodes]
}