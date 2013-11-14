class Seed < ActiveRecord::Base
  store 	:payload, accessors: [:uri, :cache, :headers, :delimiter, :sqlserver, :host, :port, :database, :username, :password, :query, :selectors]
  store		:memory

  has_many	:seed_mapping
  has_many	:agent, :through => :seed_mapping
end