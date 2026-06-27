######
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server 
#https://docs.aws.amazon.com/cognito/latest/developerguide/federation-endpoints-oauth-grants.html 
#Cognito resource server
resource "aws_cognito_resource_server" "satellite_resource" {
  identifier = "satellite_api_rest"
  name       = "RBAC REST API"

  scope {
    scope_name        = "admin-scope"
    scope_description = "Admin level permissions"
  }

  scope {
    scope_name        = "user-scope"
    scope_description = "User level permissions"
  }

  user_pool_id = aws_cognito_user_pool.satellite_pool.id
}

# Cognito user pool 1
#https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool

resource "aws_cognito_user_pool" "satellite_pool" {
  name                     = "satellite_pool"
  auto_verified_attributes = ["email"]
  mfa_configuration        = "ON"

  software_token_mfa_configuration {
    enabled = true
  }

  password_policy {
    minimum_length    = 8
    require_symbols   = false
    require_uppercase = true
    require_lowercase = true
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "verified_email"
      priority = 1
    }

    recovery_mechanism {
      name     = "verified_phone_number"
      priority = 2
    }
  }
}

#cognito user pool client
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client

resource "aws_cognito_user_pool_client" "satellite_client" {
  name                                 = "satellite_client"
  user_pool_id                         = aws_cognito_user_pool.satellite_pool.id
  callback_urls                        = ["https://localhost/callback"]
  logout_urls                          = ["https://localhost/logout"]
  generate_secret                      = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes = [
    "email",
    "openid",
    "profile",
    "${aws_cognito_resource_server.satellite_resource.identifier}/admin-scope",
    "${aws_cognito_resource_server.satellite_resource.identifier}/user-scope"
  ]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]

  //supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_group" "satellite_user_group" {
  name         = "satellite_user_group"
  user_pool_id = aws_cognito_user_pool.satellite_pool.id
  description  = "Managed by Terraform"
  precedence   = 10
  // role_arn     = aws_iam_role.group_role.arn
}

resource "aws_cognito_user_group" "satellite_admin_group" {
  name         = "satellite_admin_group"
  user_pool_id = aws_cognito_user_pool.satellite_pool.id
  description  = "Managed by Terraform"
  precedence   = 1
  // role_arn     = aws_iam_role.group_role.arn
}

# resource "aws_cognito_user" "name" {
#     user_pool_id = aws_cognito_user_pool.satellite_pool.id
#     username = "sophiejwillocks"
#     password = "value"

#     attributes = {
#       "email" = "kevinwillocks@icloud.com"
#       email_verified = true
#     }
# }