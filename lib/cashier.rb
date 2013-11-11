require 'raven'
require 'rails_config'

module Services
	class Cashier
		

		public
		def self.verify memory, agent, payload
			begin
				if Settings.cache.redis then
					@redis = Redis.new :host => Settings.cache.host, :port => Settings.cache.port
				end
			rescue Exception => e
				Raven.capture_exception(e)
			end

			if Settings.cache.redis then

				begin


				##
				# === Redis implementation
				if @redis.hexists("#{agent.identifier}:seed","#{memory}") then
					response = {:status => 100, :message => "[i2x][Cashier] Nothing to update"}
				else
					@redis.hset("#{agent.identifier}:seed", "#{memory}", payload)
					response = {:status => 100, :message => "[i2x][Cashier] Memory recorded to cache"}
				end

				
			rescue Exception => e
				response = {:message => "[i2x][Cashier] unable to verify cache content, #{e}", :status => 301}
				#puts "[i2x][Cashier] unable to verify cache content, #{e}"
				Raven.capture_exception(e)
			end
		end

		if Settings.cache.internal then
				#
				# === SQL implementation
				
				results = Cache.where memory: memory, agent_id: agent.id
				if results.size == 0 then
					begin
						@cached = Cache.new({:memory => memory, :agent_id => agent.id, :payload => payload})
						@cached.save						
					rescue Exception => e
						response = {:message => "[i2x][Cashier] unable to save new cache content, #{e}", :status => 300}
						puts "[i2x][Cashier] unable to save new cache content, #{e}"
						Raven.capture_exception(e)
					end
				else
					response = {:status => 200, :message => "[i2x][Cashier] Nothing to update"}
				end
				
			end

			response
		end
	end
end