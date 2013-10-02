class Template < ActiveRecord::Base
	serialize 	:payload #, :memory

	after_initialize	:symbolize
	after_create		:symbolize

	def symbolize
		payload.symbolize_keys!
		#memory.symbolize_keys!
	end
end
