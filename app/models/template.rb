class Template < ActiveRecord::Base
	store 	:payload
	store	:memory
	serialize	:variables

#	after_initialize	:symbolize
#	before_save	:normalize

	def symbolize
		#payload.symbolize_keys!
		#memory.symbolize_keys!
	end

	#def before_save(record)
	#	record.payload.to_json
	#end
end
