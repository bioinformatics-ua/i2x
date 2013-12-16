class Event < ActiveRecord::Base
	store	:memory
	store	:payload
	
	belongs_to :agent

	##
	# => Get all events for the given user.
	#
	def self.by_user user
		begin
			@events = Array.new
			@agents = user.agent
			@agents.each do |agent|
				agent.event.each do |e|
					@events.push(e)
				end
			end
		rescue Exception => e
			Services::Slog.exception e
		end
		@events
	end
end
