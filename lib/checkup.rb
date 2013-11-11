require 'delayed_job'
require 'csv'
require 'detector'
require 'sqldetector'
require 'csvdetector'
require 'xmldetector'
require 'raven'
require 'rails_config'
require 'rest-client'

module Services
	class Checkup

		def check schedule		

			begin
				if Settings.log.sentry then
					Raven.capture_message("[i2x][Checkup] Starting checkup", { 
						:level => 'debug', 
						:tags => {
   							'environment' => Rails.env,
   							'version' => Settings.app.version,
   							'module' => 'Checkup',
   							'task' => 'check'
  						},
  						:server_name => Settings.app.host,
						:extra => {
							'schedule' => schedule
						}
					})
				end
			rescue => e
				Raven.capture_exception(e)
			end

			@agents = Agent.where( :schedule => schedule).where("last_check_at < CURRENT_TIMESTAMP - INTERVAL 2 MINUTE")
			@checkup = {}
			@agents.each do |agent|
				if Settings.log.sentry then
									Raven.capture_message("[i2x][Checkup] Processing agent #{agent.identifier}", { 
										:level => 'info', 
										:tags => {
					 							'environment' => Rails.env,
					 							'version' => Settings.app.version,
					 							'module' => 'Checkup',
					 							'task' => 'agent'
											},
											:server_name => Settings.app.host,
										:extra => {
											'agent' => agent.identifier,
											'publisher' => agent.publisher
										}
									})
								end

				case agent.publisher
					when 'sql'
						begin
							@d = Services::SQLDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							Raven.capture_exception(e)
							@response = {:status => 400, :error => e}
						end
					when 'csv'
						begin
							@d = Services::CSVDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							Raven.capture_exception(e)
							@response = {:status => 400, :error => e}
						end
					when 'xml'
						begin
							@d = Services::XMLDetector.new(agent.identifier)
							@checkup = @d.checkup
						rescue Exception => e
							Raven.capture_exception(e)
							@response = {:status => 400, :error => e}
						end
					when 'json'	
						@response = {:status => 404, :error => "[i2x][Checkup] JSON detection is not implemented"}

				end

				begin
					if @checkup[:status] == 100 then
					#	puts "Starting integrations processing"
						Raven.capture_message("[i2x][Checkup] Starting integrations processing", { 
											:level => 'info', 
											:tags => {
						 							'environment' => Rails.env,
						 							'version' => Settings.app.version,
						 							'module' => 'Checkup',
						 							'task' => 'integration'
												},
												:server_name => Settings.app.host,
											:extra => {
												'agent' => agent.identifier,
												'payload' => @checkup[:payload].size
											}
										})
						
						## this should be simpler!!!
						AgentMapping.where(:agent_id => agent.id).each do |mapping|
							Integration.where(:id => mapping.integration_id).each do |integration|							
								integration.template.each do |t|
									#puts "\t\tProcessing Template #{t.identifier}"
									Raven.capture_message("[i2x][Checkup] Sending #{agent.identifier} for delivery by #{t.identifier}", { 
														:level => 'info', 
														:tags => {
									 							'environment' => Rails.env,
									 							'version' => Settings.app.version,
									 							'module' => 'Checkup',
									 							'task' => 'delivery'
															},
															:server_name => Settings.app.host,
														:extra => {
															'template' => t.identifier,
															'payload' => @checkup[:payload].size,
															'agent' => agent.identifier
														}
													})
									@checkup[:payload].each do |payload|
										
										RestClient.post "#{Settings.app.host}postman/deliver/#{t.identifier}.js", payload
									end
								end
							end
						end
					else
					end
				rescue Exception => e
					Raven.capture_exception(e)
				end
				#dt = Time.new
	    		#File.open('data/log.csv', 'a') { |file| file.write("#{schedule},#{@checkup},#{agent.identifier},#{dt.to_time}\n") }
			end
			
		end
  		handle_asynchronously :check
	end
end