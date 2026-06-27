data "aws_region" "current" {}
data "aws_partition" "current" {}
data "aws_caller_identity" "current" {}

# TODO: UPDATE THIS!!!!!!!
# data "aws_iam_policy_document" "waf_log_policy" {
#   version = "2012-10-17"
#   statement {
#     effect = "Allow"
#     principals {
#       identifiers = ["delivery.logs.amazonaws.com"]
#       type        = "Service"
#     }
    
#     actions   = ["logs:CreateLogStream", "logs:PutLogEvents"]
#     resources = ["${aws_cloudwatch_log_group.waf_logs.arn}:*"]
#     condition {
#       test = "ArnLike"
#       values = [ "${aws_wafv2_web_acl.my_api_waf.arn}:*" ]
#       variable = "aws:SourceArn"
#     }
#   }
# }