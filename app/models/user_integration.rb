class UserIntegration < ActiveRecord::Base
  belongs_to	:user
  belongs_to	:integration
end