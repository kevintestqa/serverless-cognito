# Cognito:
# 1. OAuth/JWT identity
# 2. issue ID/access/refresh tokens
# 3. REST API validates access tokens locally using Cognito’s JWKS/public keys.


# RBAC Flow:
# 1. User authenticates with Cognito.
# 2. Cognito issues an access token with scopes like rbac-api/admin or rbac-api/user.
# 3. API Gateway Cognito authorizer validates the token.
# 4. API Gateway checks authorization_scopes.
# 5. Only then does Lambda run.
# 6. Lambda optionally checks cognito:groups for Layer 2 defense/application logic.

# API Gateway with Cognito:
Create a COGNITO_USER_POOLS authorizer.
Point it at the Cognito user pool.
Attach the authorizer to the protected API method.
Client must call API Gateway with Cognito JWT