require 'helper'
require 'cashier'
require 'csv'
require 'open-uri'

module Services

	# = CSVDetector
	#
	# Detect changes in CSV files (using column numbers).
	#
	class CSVDetector < Detector
		
		public

		def checkup
			@help = Services::Helper.new
			begin
				#@content
				 #open(@agent[:options][:uri]) {|f| @content = f.read()}
				 CSV.new(open(@agent[:options][:uri]), :headers => :first_row).each do |row|
				 	unless @agent[:options][:content_id].nil? then
						@response = Cashier.verify row[@agent[:options][:content_id]], @agent, row
					else
						@response = Cashier.verify row[0], @agent, row
					end
				end
				@response = {:status => 200}
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][CSVDetector] failed to load CSV doc, #{e}"}
				puts "[i2x][CSVDetector] failed to load CSV doc, #{e}"
			end

			@response
		end
	end
end