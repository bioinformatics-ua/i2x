class Integration < ActiveRecord::Base
  store	:payload
  store	:memory

  ##
  # => Use IntegrationMappings to connect Templates
  #
  has_many	:integration_mapping
  has_many	:template, :through => :integration_mapping

  ##
  # => Use AgentMappings to connect Agents
  #
  has_many	:agent_mapping
  has_many	:agent, :through => :agent_mapping

  ##
  # => Use  User Integrations  to connect Users
  #
  has_many  :user_integrations
  has_many  :user, :through => :user_integrations
end