#AWS
provider "aws" {
  region = "ap-south-1"
}

#iam role policy
resource "aws_iam_role" "ec2_iam_role" {
  name = "ec2-cluster-iam-role"


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


resource "aws_iam_role" "eks_iam_role" {
  name = "eks-cluster-iam-role"


  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "ClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks_iam_role.name
}


resource "aws_iam_role_policy_attachment" "ServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role = aws_iam_role.eks_iam_role.name
}


resource "aws_iam_role_policy_attachment" "WorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.ec2_iam_role.name
}


resource "aws_iam_role_policy_attachment" "EKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.ec2_iam_role.name
}


resource "aws_iam_role_policy_attachment" "EC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.ec2_iam_role.name
}

#EKS cluster creation
resource "aws_eks_cluster" "eks_cluster" {
  name = "ekscluster"
  role_arn = aws_iam_role.eks_iam_role.arn

  vpc_config {
    subnet_ids = ["subnet-45acc709", "subnet-4ba59f23", "subnet-cda914b6"]
  }


  tags = {
    Name = "EKS_Cluster"
  }


  depends_on = [
    aws_iam_role_policy_attachment.ClusterPolicy,
    aws_iam_role_policy_attachment.ServicePolicy,
  ]
}

resource "aws_eks_node_group" "Node1" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node1"
  node_role_arn = aws_iam_role.ec2_iam_role.arn
  subnet_ids = ["subnet-45acc709", "subnet-4ba59f23", "subnet-cda914b6"]
  instance_types = ["t2.micro"]  
  disk_size = 40  
  remote_access {
    ec2_ssh_key = "ec2key"
    source_security_group_ids = ["sg-0ac83d08cc87f1d87"]
  }


  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }


  depends_on = [
    aws_iam_role_policy_attachment.WorkerNodePolicy,
    aws_iam_role_policy_attachment.EKS_CNI_Policy,
    aws_iam_role_policy_attachment.EC2ContainerRegistryReadOnly
  ]
}


resource "aws_eks_node_group" "Node2" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node2"
  node_role_arn = aws_iam_role.ec2_iam_role.arn
  subnet_ids = ["subnet-45acc709", "subnet-4ba59f23", "subnet-cda914b6"]
  instance_types = ["t2.micro"]
  disk_size = 40  
  remote_access {
    ec2_ssh_key = "ec2key"
    source_security_group_ids = ["sg-0ac83d08cc87f1d87"]
  }
  
  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }


   depends_on = [
    aws_iam_role_policy_attachment.WorkerNodePolicy,
    aws_iam_role_policy_attachment.EKS_CNI_Policy,
    aws_iam_role_policy_attachment.EC2ContainerRegistryReadOnly
  ]
}


resource "aws_eks_node_group" "Node3" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-node3"
  node_role_arn = aws_iam_role.ec2_iam_role.arn
  subnet_ids = ["subnet-45acc709", "subnet-4ba59f23", "subnet-cda914b6"]
  instance_types = ["t2.micro"]
  disk_size = 40  
  remote_access { 
    ec2_ssh_key = "ec2key"
    source_security_group_ids = ["sg-0ac83d08cc87f1d87"]
  }
  scaling_config {
    desired_size = 1
    max_size = 1
    min_size = 1
  }


   depends_on = [
    aws_iam_role_policy_attachment.WorkerNodePolicy,
    aws_iam_role_policy_attachment.EKS_CNI_Policy,
    aws_iam_role_policy_attachment.EC2ContainerRegistryReadOnly
  ]
}
