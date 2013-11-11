class AgentMapping < ActiveRecord::Base
  belongs_to	:integration
  belongs_to	:agent
end