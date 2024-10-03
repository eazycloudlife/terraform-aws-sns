resource "aws_sns_topic" "this" {
  count = var.create ? 1 : 0

  name         = var.name_prefix ? null : (var.fifo_topic ? "${local.name}.fifo" : local.name)
  name_prefix  = var.name_prefix ? "${local.name}-" : null
  display_name = var.display_name

  application_failure_feedback_role_arn    = try(var.application_feedback.failure_role_arn, null)
  application_success_feedback_role_arn    = try(var.application_feedback.success_role_arn, null)
  application_success_feedback_sample_rate = try(var.application_feedback.success_sample_rate, null)

  content_based_deduplication = var.content_based_deduplication
  delivery_policy             = var.delivery_policy
  fifo_topic                  = var.fifo_topic
  signature_version           = var.fifo_topic ? null : var.signature_version
  tracing_config              = var.tracing_config

  firehose_failure_feedback_role_arn    = try(var.firehose_feedback.failure_role_arn, null)
  firehose_success_feedback_role_arn    = try(var.firehose_feedback.success_role_arn, null)
  firehose_success_feedback_sample_rate = try(var.firehose_feedback.success_sample_rate, null)

  http_failure_feedback_role_arn    = try(var.http_feedback.failure_role_arn, null)
  http_success_feedback_role_arn    = try(var.http_feedback.success_role_arn, null)
  http_success_feedback_sample_rate = try(var.http_feedback.success_sample_rate, null)

  kms_master_key_id = var.kms_master_key_id

  lambda_failure_feedback_role_arn    = try(var.lambda_feedback.failure_role_arn, null)
  lambda_success_feedback_role_arn    = try(var.lambda_feedback.success_role_arn, null)
  lambda_success_feedback_sample_rate = try(var.lambda_feedback.success_sample_rate, null)

  policy = var.create_topic_policy ? null : var.topic_policy

  sqs_failure_feedback_role_arn    = try(var.sqs_feedback.failure_role_arn, null)
  sqs_success_feedback_role_arn    = try(var.sqs_feedback.success_role_arn, null)
  sqs_success_feedback_sample_rate = try(var.sqs_feedback.success_sample_rate, null)

  archive_policy = try(var.archive_policy, null)

  tags = var.tags
}

resource "aws_sns_topic_policy" "this" {
  count = var.create && var.create_topic_policy ? 1 : 0

  arn    = aws_sns_topic.this[0].arn
  policy = data.aws_iam_policy_document.this[0].json
}

resource "aws_sns_topic_subscription" "this" {
  for_each = { for k, v in var.subscriptions : k => v if var.create && var.create_subscription }

  confirmation_timeout_in_minutes = try(each.value.confirmation_timeout_in_minutes, null)
  delivery_policy                 = try(each.value.delivery_policy, null)
  endpoint                        = each.value.endpoint
  endpoint_auto_confirms          = try(each.value.endpoint_auto_confirms, null)
  filter_policy                   = try(each.value.filter_policy, null)
  filter_policy_scope             = try(each.value.filter_policy_scope, null)
  protocol                        = each.value.protocol
  raw_message_delivery            = try(each.value.raw_message_delivery, null)
  redrive_policy                  = try(each.value.redrive_policy, null)
  replay_policy                   = try(each.value.replay_policy, null)
  subscription_role_arn           = try(each.value.subscription_role_arn, null)
  topic_arn                       = aws_sns_topic.this[0].arn
}

resource "aws_sns_topic_data_protection_policy" "this" {
  count = var.create && var.data_protection_policy != null && !var.fifo_topic ? 1 : 0

  arn    = aws_sns_topic.this[0].arn
  policy = var.data_protection_policy
}
