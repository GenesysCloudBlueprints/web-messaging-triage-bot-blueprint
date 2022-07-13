/*
  Creates the queue
*/
resource "genesyscloud_routing_queue" "queue" {
  name = "web-messaging-triage-bot-queue"
  members {
    user_id  = var.userId
  }
  wrapup_codes = [var.wrapup_processed_id, var.wrapup_resolved_id]
}
