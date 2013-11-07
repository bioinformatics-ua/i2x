require 'helper'
require 'cashier'
require 'open-uri'

module Services

	# = XMLDetector
	#
	# Detect changes in XML files (uses XPath).
	#
	class XMLDetector < Detector
		
		public

		def checkup
			@help = Services::Helper.new
			begin
				@doc = Nokogiri::XML(open(@agent[:payload][:uri]))				
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][XMLDetector] failed to load XML doc, #{e}"}
				puts "[i2x][XMLDetector] failed to load XML doc, #{e}"
			end

			begin
				@doc.remove_namespaces!
				@doc.xpath(@agent[:payload][:cache]).each do |element|
					@cache = Cashier.verify element.content, @agent, element.content
				end

				# The actual processing
					#
					if @cache[:status] == 100 then

							# add row data to payload from selectors (key => key, value => column name)
							payload = Hash.new
							JSON.parse(@agent[:payload][:selectors]).each do |selector|
								
								selector.each do |k,v|
									@doc.xpath(v).each do |element|
										payload[k] = element.content
									end
								end
							end
							# add payload object to payloads list
							@payloads.push payload
							# increase detected events count
							@agent.increment!(:events_count)						

						end

						@response = { :payload => @payloads, :status => 100}
					rescue Exception => e
						@response = {:status => 404, :message => "[i2x][XMLDetector] failed to process XPath, #{e}"}
						puts "[i2x][XMLDetector] failed to process XPath, #{e}"
					end

					@response
				end
			end
		end