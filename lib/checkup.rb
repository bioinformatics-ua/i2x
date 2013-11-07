require 'delayed_job'
require 'csv'
require 'detector'
require 'sqldetector'
require 'csvdetector'
require 'xmldetector'
require 'raven'

module Services
	class Checkup

		def check schedule		

			begin
				lol
			rescue => e
				Raven.capture_exception(e)
			end

			@agents = Agent.where( :schedule => schedule)
			@checkup = {}
			@agents.each do |agent|

				case agent.publisher
					when 'sql'
						begin
							@d = Services::SQLDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							puts e
							@response = {:status => 400, :error => e}
						end
					when 'csv'
						begin
							@d = Services::CSVDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							puts e
							@response = {:status => 400, :error => e}
						end
					when 'xml'
						begin
							@d = Services::XMLDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							puts e
							@response = {:status => 400, :error => e}
						end
					when 'json'	
						@response = {:status => 404, :error => "[i2x][Checkup] JSON detection is not implemented"}

				end

				begin
					if @checkup[:status] == 100 then
						puts "Starting integrations processing"
						
						## this should be simpler!!!
						AgentMapping.where(:agent_id => agent.id).each do |mapping|
							Integration.where(:id => mapping.integration_id).each do |integration|							
								integration.template.each do |t|
									puts "\t\tProcessing Template #{t.identifier}"
									@checkup[:payload].each do |payload|
										puts RestClient.post "#{Rails.configuration.host}postman/deliver/#{t.identifier}.js", payload
									end
								end
							end
						end
					else
					end
				rescue Exception => e
					puts e.inspect
				end
				dt = Time.new
	    		File.open('data/log.csv', 'a') { |file| file.write("#{schedule},#{@checkup},#{agent.identifier},#{dt.to_time}\n") }
			end
			
		end
  		#handle_asynchronously :check
	end
end