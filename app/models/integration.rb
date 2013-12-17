class Integration < ActiveRecord::Base
  store	:payload
  store	:memory

  ##
  # => Use IntegrationMappings to connect Templates
  #
  has_many	:integration_mapping
  has_many	:templates, :through => :integration_mapping

  ##
  # => Use AgentMappings to connect Agents
  #
  has_many	:agent_mapping
  has_many	:agents, :through => :agent_mapping

  ##
  # => Use  User Integrations  to connect Users
  #
  has_many  :user_integrations
  has_many  :users, :through => :user_integrations
end