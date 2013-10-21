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
				@doc = Nokogiri::XML(open(@agent[:options][:uri]))				
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][XMLDetector] failed to load XML doc, #{e}"}
				puts "[i2x][XMLDetector] failed to load XML doc, #{e}"
			end

			begin
				@doc.remove_namespaces!
				@doc.xpath(@agent[:options][:content_id]).each do |element|
					@response = Cashier.verify element.content, @agent, element.content
				end
				@response = {:status => 200}
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][XMLDetector] failed to process XPath, #{e}"}
				puts "[i2x][XMLDetector] failed to process XPath, #{e}"
			end

			@response
		end
	end
end