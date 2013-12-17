class Template < ActiveRecord::Base
  store 	:payload
  store	:memory
  serialize	:variables

  ##
  # => Use IntegrationMappings to connect Integrations
  #
  has_many	:integration_mapping
  has_many	:integrations, :through => :integration_mapping

  ##
  # => Use  User Templates  to connect Users
  #
  has_many  :user_template
  has_many  :users, :through => :user_templates
end