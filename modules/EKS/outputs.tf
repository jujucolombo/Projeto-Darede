output "cluster_name" {
  description = "Nome Cluster: "
  value       = aws_eks_cluster.darede-cluster.name
}

output "cluster_endpoint" {
  description = "Endpoint do cluster EKS"
  value       = data.aws_eks_cluster.host.endpoint
}