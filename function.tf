# Package the Lambda function code
data "archive_file" "node_archive" {
  type        = "zip"
  source_file = "${path.module}/source/auth.js"
  output_path = "${path.module}/lambda/node.zip"
}

# Lambda function
resource "aws_lambda_function" "node_auth" {
  filename      = data.archive_file.node_archive.output_path
  function_name = "node_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auth.handler"
  code_sha256   = data.archive_file.node_archive.output_base64sha256

  runtime = "nodejs24.x"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }
}

///Python

# Package the Lambda function code
data "archive_file" "python_archive" {
  type        = "zip"
  source_file = "${path.module}/source/auth.py"
  output_path = "${path.module}/lambda/python.zip"
}

# Lambda function
resource "aws_lambda_function" "python_auth" {
  filename      = data.archive_file.python_archive.output_path
  function_name = "python_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "auth.lambda_handler"
  code_sha256   = data.archive_file.python_archive.output_base64sha256

  runtime = "python3.14"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }
}

data "archive_file" "unused_token_archive" {
  type        = "zip"
  source_file = "${path.module}/source/unused_token.py"
  output_path = "${path.module}/lambda/unused_token.zip"
}

# Lambda function
resource "aws_lambda_function" "unused_token" {
  filename      = data.archive_file.python_archive.output_path
  function_name = "unused_token_lambda_function"
  role          = aws_iam_role.lambda_role.arn
  handler       = "unused_token.lambda_handler"
  code_sha256   = data.archive_file.python_archive.output_base64sha256

  runtime = "python3.14"

  environment {
    variables = {
      ENVIRONMENT = "production"
      LOG_LEVEL   = "info"
    }
  }
}

resource "aws_lambda_function" "waf_bedrock_analyzer" {
  filename      = data.archive_file.waf_bedrock_anaylzer.output_path
  function_name = "waf_bedrock_analyzer"
  role          = aws_iam_role.lambda_role.arn
  handler       = "waf_bedrock_analyzer.lambda_handler"
  code_sha256   = data.archive_file.waf_bedrock_anaylzer.output_base64sha256

  runtime = "python3.14"

  environment {
    variables = {
      ENVIRONMENT    = "production"
      LOG_LEVEL      = "info"
      WAF_LOG_GROUP  = aws_cloudwatch_log_group.waf_logs.name
      DYNAMODB_TABLE = "waf-events"
    }
  }
}

data "archive_file" "waf_bedrock_anaylzer" {
  type        = "zip"
  source_file = "${path.module}/source/waf_bedrock_analyzer.py"
  output_path = "${path.module}/lambda/waf_bedrock_analyzer.zip"
}
