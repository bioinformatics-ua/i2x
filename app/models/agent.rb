class Agent < ActiveRecord::Base
	##
	# => Store for saving Hashes in DB
	# => Accessors to make everything easy to access	
	#
	store 	:payload, accessors: [:uri, :cache, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors]
	store	:memory
	
	##
	# => Use SeedMappings to connect Seeds
	#
	has_many	:seed_mapping
	has_many	:seed, :through => :seed_mapping
end
