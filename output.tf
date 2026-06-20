output "python_api_url" {
  value = "${aws_api_gateway_stage.qa_environment.invoke_url}/${aws_api_gateway_resource.python_resource.path_part}?name=Kevin"
}

output "node_api_url" {
  value = "${aws_api_gateway_stage.qa_environment.invoke_url}/${aws_api_gateway_resource.node_resource.path_part}?name=Kevin"
}

# Cognito outputs for user management and token flows
output "cognito_admin_user_pool_id" {
  value       = aws_cognito_user_pool.satellite_pool.id
  description = "Cognito admin user pool ID"
}

output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.satellite_pool.id
  description = "Cognito user pool ID"
}

output "cognito_user_pool_client_id" {
  value       = aws_cognito_user_pool_client.satellite_client.id
  description = "Default Cognito app client ID for RBAC admin/user testing"
}

output "cognito_admin_user_pool_client_id" {
  value       = aws_cognito_user_pool_client.satellite_client.id
  description = "Cognito app client ID allowed to request admin and user scopes"
}

output "cognito_admin_issuer_url" {
  value = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.satellite_pool.id}"
}

output "cognito_user_issuer_url" {
  value       = "https://cognito-idp.${var.region}.amazonaws.com/${aws_cognito_user_pool.satellite_pool.id}"
  description = "OIDC issuer URL for user pool"
}
