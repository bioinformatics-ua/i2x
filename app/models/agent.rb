class Agent < ActiveRecord::Base
	store 	:payload, accessors: [:uri, :content_id]
	store	:memory
	store	:seed
end
