resource "aws_security_group" "sec-eks" {
  name        = "${var.cluster_name}-sg"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
}

resource "aws_eks_cluster" "darede-cluster" {
  name = var.cluster_name
  role_arn = var.service_role_arn

  vpc_config {
    subnet_ids = module.vpc.public_subnets
    security_group_ids = [aws_security_group.sec-eks.id]
  }
}

resource "aws_eks_node_group" "eks-node-group" {
  depends_on = [aws_eks_cluster.darede-cluster]
  cluster_name = aws_eks_cluster.darede-cluster.name
  node_group_name = var.nodes_name
  node_role_arn = var.instance_role_arn
  subnet_ids = module.vpc.private_subnets
  
  scaling_config {
    desired_size = 1
    max_size = 2
    min_size = 1
  }

}

resource "kubernetes_manifest" "deploy" {
  manifest = file("${path.module}/deploy.yaml")
}

resource "kubernetes_manifest" "service" {
  manifest = file("${path.module}/service.yaml")
}

resource "kubernetes_manifest" "ingress" {
  manifest = file("${path.module}/ingress.yaml")
}
