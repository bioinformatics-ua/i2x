class Event < ActiveRecord::Base
	store	:memory
	store	:payload
	
	belongs_to :agent
end
