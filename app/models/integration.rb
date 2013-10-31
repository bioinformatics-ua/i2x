class Integration < ActiveRecord::Base
	store	:payload
	store	:memory

	##
	# => Use IntegrationMappings to connect Templates
	#
	has_many	:integration_mapping
	has_many	:template, :through => :integration_mapping
end
