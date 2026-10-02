output "execution_role_arn" {
  value = aws_iam_role.ecs_execution_role.arn
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.cluster.arn
}