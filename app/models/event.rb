class Event < ActiveRecord::Base
	store	:memory
	store	:payload
	
	belongs_to :agent
	has_many :users

	##
	# => Get all events for the given user.
	#
	def self.by_user user
		begin
			@events = Event.joins(agent: :users).where(users: {:id => user.id}).order(created_at: :desc)
		rescue Exception => e
			Services::Slog.exception e
		end
		@events
	end

	##
	# => Get all events for the given user (limit).
	#
	def self.by_user_limit user
		begin
			@events = Event.joins(agent: :users).where(users: {:id => user.id}).order(created_at: :desc).limit(8)
		rescue Exception => e
			Services::Slog.exception e
		end
		@events
	end
end
