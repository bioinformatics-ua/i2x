class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :marketable

  ##
  # => Use  User Agents  to connect Agents
  #
  has_many  :user_agents
  has_many  :agent, :through => :user_agents

  ##
  # => Use  User Templates  to connect Templates
  #
  has_many  :user_templates
  has_many  :template, :through => :user_templates

  ##
  # => Use  User Integrations  to connect Integrations
  #
  has_many  :user_integrations
  has_many  :integration, :through => :user_integrations
end