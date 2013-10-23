class Agent < ActiveRecord::Base
	store 	:payload, accessors: [:payload_uri, :payload_cache, :payload_headers, :payload_delimiter, :payload_sqlserver, :payload_host, :payload_port, :payload_database, :payload_username, :payload_password, :payload_query, :payload_selectors]
	store	:seed, accessors: [:seed_uri, :seed_cache, :seed_headers, :seed_delimiter, :seed_sqlserver, :seed_host, :seed_port, :seed_database, :seed_username, :seed_password, :seed_query, :seed_selectors]
end
