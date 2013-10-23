class Agent < ActiveRecord::Base
	store 	:payload, accessors: [:uri, :cache, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors]
end
