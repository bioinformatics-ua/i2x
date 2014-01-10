class Template < ActiveRecord::Base
  store 	:payload, accessors: [:method, :content,:uri, :cache, :checked, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors, :server, :to, :cc, :bcc, :subject, :message]
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
  has_many  :user_templates
  has_many  :users, :through => :user_templates

  ##
  # => Update time for last execute.
  #
  def update_execute_at time
    begin
      self.last_execute_at = time
      self.save
    rescue Exception => e
      Services::Slog.exception e
    end
    
  end
end