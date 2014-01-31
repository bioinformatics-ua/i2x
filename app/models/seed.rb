class Seed < ActiveRecord::Base
  store 	:payload, accessors: [:uri, :cache, :headers, :delimiter, :server, :host, :port, :database, :username, :password, :query, :selectors, :checked]
  store		:memory

  has_many	:seed_mapping
  has_many	:agents, :through => :seed_mapping

end