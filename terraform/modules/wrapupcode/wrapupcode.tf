/*
  Creates the wrap-up codes
*/
resource "genesyscloud_routing_wrapupcode" "processed" {
  name = "Message Processed"
}

resource "genesyscloud_routing_wrapupcode" "resolved" {
  name = "Message Resolved"
}