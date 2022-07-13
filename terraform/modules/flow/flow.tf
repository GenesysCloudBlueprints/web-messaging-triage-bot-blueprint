resource "genesyscloud_flow" "inbound_message_flow" {
  filepath = "${path.module}/web-messaging-triage-bot.yaml"
  substitutions = {
    flow_name             = "web-messaging-triage-bot-flow"
    default_language      = "en-us"
    queue_name            = "web-messaging-triage-bot-queue"
    data_action_category  = var.data_action_category
    data_action_name      = var.data_action_name
  }
}

resource "genesyscloud_flow" "bot_flow" {
  filepath = "${path.module}/quick-response-bot.yaml"
  substitutions = {
    flow_name           = "web-messaging-quick-response-bot"
    default_language    = "en-us"
  }
}