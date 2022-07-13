/*
  Create a Data Action integration
*/
module "data_action" {
  source                          = "git::https://github.com/GenesysCloudDevOps/public-api-data-actions-integration-module?ref=main"
  integration_name                = "web-messaging-triage-bot-data-action"
  integration_creds_client_id     = var.client_id
  integration_creds_client_secret = var.client_secret
}

/*
  Create a Get Agent Wrapup and Time from Conversation Data Action
*/
module "get_agent_wrapup_and_time_from_conversation_data_action" {
  source             = "git::https://github.com/GenesysCloudDevOps/public-api-get-last-contact-state-data-action-module?ref=main"
  action_name        = "Get Agent Wrap-Up and Time from Conversation"
  action_category    = "${module.data_action.integration_name}"
  integration_id     = "${module.data_action.integration_id}"
  secure_data_action = false
}

/*   
   Configures the wrap up codes
*/
module "wrap_up_codes" {
  source      = "./modules/wrapupcode"
}

/*
   Looks up the id of the user so we can associate it with the queue
*/
data "genesyscloud_user" "user" {
  email = var.email
}

/*
   Creates the queue used within the flow
*/
module "queue" {
  source              = "./modules/queue"
  userId              = data.genesyscloud_user.user.id
  wrapup_processed_id = module.wrap_up_codes.wrapup_processed_id
  wrapup_resolved_id  = module.wrap_up_codes.wrapup_resolved_id
}

/*   
   Configures the architect inbound message flow
*/
module "archy_flow" {
  source                = "./modules/flow"
  data_action_category  = module.data_action.integration_name
  data_action_name      = module.get_agent_wrapup_and_time_from_conversation_data_action.data_action_name
}

/*   
   Configures the web deployment configuration
*/
module "web_config" {
  source      = "./modules/webdeployments_configuration"
}

/*   
   Configures the web deployment
*/
module "web_deploy" {
  source      = "./modules/webdeployments_deployment"
  flowId      = module.archy_flow.flow_id
  configId    = module.web_config.config_id
  configVer   = module.web_config.config_ver
}
