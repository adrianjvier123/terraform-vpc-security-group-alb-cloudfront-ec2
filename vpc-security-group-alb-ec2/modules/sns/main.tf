resource "aws_sns_topic" "SNS_CPU_Utilization" {
  name = "SNS_CPU_Utilization"
}

resource "aws_sns_topic_subscription" "user_updates_sqs_target" {
  topic_arn = aws_sns_topic.SNS_CPU_Utilization.arn
  protocol  = "sms"
  endpoint  = "+57 3102210623"
}