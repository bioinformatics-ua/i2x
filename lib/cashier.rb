module Services
	class Cashier
		@redis = Redis.new

		public
		def self.verify memory, agent, payload
			begin

				##
				# === Redis implementation
				if @redis.hexists("#{agent.identifier}:seed","#{memory}") then
					response = {:status => 200, :message => "[i2x][Cashier] Nothing to update"}
				else
					@redis.hset("#{agent.identifier}:seed", "#{memory}", payload)
				end

				##
				# === SQL implementation
				#
				#results = Cache.where memory: memory, agent_id: agent.id
				#if results.size == 0 then
				#	begin
				#		@cached = Cache.new({:memory => memory, :agent_id => agent.id, :payload => payload})
				#		@cached.save						
				#	rescue Exception => e
				#		response = {:message => "[i2x][Cashier] unable to save new cache content, #{e}", :status => 300}
				#		puts "[i2x][Cashier] unable to save new cache content, #{e}"
				#	end
				#else
				#	response = {:status => 200, :message => "[i2x][Cashier] Nothing to update"}
				#end
				response = {:status => 200}
			rescue Exception => e
				response = {:message => "[i2x][Cashier] unable to verify cache content, #{e}", :status => 301}
				puts "[i2x][Cashier] unable to verify cache content, #{e}"
			end

			response
		end
	end
end