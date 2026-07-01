resource "aws_wafv2_web_acl_logging_configuration" "waf_logging_config" {
  log_destination_configs = [aws_cloudwatch_log_group.waf_logs.arn]
  resource_arn            = aws_wafv2_web_acl.satellite_waf_v2.arn

  depends_on = [aws_cloudwatch_log_resource_policy.waf_logs_resource_policy]
}

resource "aws_cloudwatch_log_group" "waf_logs" {
  name = "aws-waf-logs-chewbacca"
}

resource "aws_cloudwatch_log_resource_policy" "waf_logs_resource_policy" {
  policy_document = data.aws_iam_policy_document.waf_log_policy.json
  policy_name     = "WAF-logging-policy"
}