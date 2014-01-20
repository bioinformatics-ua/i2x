class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable, :marketable, :omniauthable
  validates_presence_of :email
  
  ##
  # => Use  User Agents  to connect Agents
  #
  has_many  :user_agents
  has_many  :agents, :through => :user_agents

  ##
  # => Use  User Templates  to connect Templates
  #
  has_many  :user_templates
  has_many  :templates, :through => :user_templates

  ##
  # => Use  User Integrations  to connect Integrations
  #
  has_many  :user_integrations
  has_many  :integrations, :through => :user_integrations

  ##
  # => User has many Authorizations from social sites
  #
  has_many :authorizations

  ##
  # => User has many keys for access
  #
  has_many :api_keys


  def self.new_with_session(params,session)
    if session["devise.user_attributes"]
      new(session["devise.user_attributes"],without_protection: true) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end

  def self.from_omniauth(auth, current_user)
    authorization = Authorization.where(:provider => auth.provider, :uid => auth.uid.to_s, :token => auth.credentials.token, :secret => auth.credentials.secret).first_or_initialize
    if authorization.user.blank?
      user = current_user.nil? ? User.where('email = ?', auth["info"]["email"]).first : current_user
      if user.blank?
       user = User.new
       user.password = Devise.friendly_token[0,10]
       user.name = auth.info.name
       user.email = auth.info.email
       if (auth.provider == "twitter") then
        user.email = user.name + '@twitter.com'
       end
       user.save
       #user.save(:validate => false)
     end
     authorization.username = auth.info.nickname
     authorization.user_id = user.id
     authorization.save
   end
   authorization.user
 end
end