require 'helper'

module Services
	
	##
	# = Delivery
	#
	# Main Delivery class, to be inherited by SQL, File and URL
	#
	class Delivery
		attr_accessor :template, :identifier, :publisher

		def initialize identifier, publisher
			@identifier = identifier
			@publisher = publisher
			@template = Template.find_by! identifier: @identifier, publisher: @publisher

			self.process_helpers
		end

		
		## 
	  	# Replaces all identified variables with the matching properties in the payload
	  	#
	  	# ==== Parameters
	  	#
	  	# * +params+ - the Postman URL POST request parameters
	  	# 
	  	def process params
	  		@template[:variables].each do |variable|
	  			begin
	  				@template[:payload].each_pair do |key,value|
	  					@template[:payload][key].gsub!("%{#{variable}}", params[variable])
	  				end
	  			rescue => e
	  				puts e
	  			end
	  		end
	  	end

	  	## 
	  	# Replaces all identified helpers with the matching helper functions output in the payload
	  	#
	  	def process_helpers
	  		@help = Services::Helper.new

	  		begin
	  			@template[:payload].each_pair do |key, value|
	  				@help.replacements.each {|replacement| @template[:payload][key].gsub!(replacement[0], replacement[1])}
	  			end
	  		rescue => e
	  			puts e
	  		end
	  	end

	  	##
	  	# => Execute final delivery, to be override by inherited classes
	  	#
	  	def execute
	  	end

	end
end