class UserAgent < ActiveRecord::Base
  belongs_to	:user
  belongs_to	:agent
end