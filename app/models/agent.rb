class Agent < ActiveRecord::Base
	store 	:options, accessors: [:uri, :content_id]
	store	:memory
	store	:seed
end
