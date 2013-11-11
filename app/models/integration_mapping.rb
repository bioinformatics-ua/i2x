class IntegrationMapping < ActiveRecord::Base
  belongs_to	:integration
  belongs_to	:template
end