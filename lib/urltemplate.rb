require 'delivery'

module Services
	class URLTemplate < Delivery

		public

		##
		# => Performs the actual delivery, in this case, execure SQL query.
		#
		def execute
			case @template[:payload][:method]
			when 'get'
				begin
					out = RestClient.get @template[:payload][:uri]
					response = {:status => 200, :message => "[i2] GET request on #{@template[:payload][:uri]} executed.", :id => @template[:payload][:uri], :response => out.to_str}
				rescue Exception => e
					response = {:status => 400, :message => "Unable to perform GET request, #{e}"}
				end
			when 'post'
				begin
					out = RestClient.post @template[:payload][:uri], @template[:payload]
					response = {:status => 200, :message => "[i2] POST request on #{@template[:payload][:uri]} executed.", :id => @template[:payload][:uri], :response => out.to_str}
				rescue Exception => e
					response = {:status => 400, :message => "Unable to perform POST request, #{e}"}
				end
			when 'put'
				begin
					
				rescue Exception => e
					response = {:status => 440, :message => "Unable to perform PUT request (not implemented), #{e}"}
				end
			when 'delete'
				begin
					
				rescue Exception => e
					response = {:status => 440, :message => "Unable to perform DELETE request (not implemented), #{e}"}
				end
			end
			response
		end
  		#handle_asynchronously :execute

		##
		# => Validates the server connection properties
		#
		def validate_properties
			true
		end
	end	

end