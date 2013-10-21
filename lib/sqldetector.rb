require 'helper'
require 'cashier'

module Services

	##
	# = SQLDetector
	#
	# Detec changes in SQL databases. MySQL support only.
	#
	class SQLDetector < Detector
		
		public

		def checkup
			
			@help = Services::Helper.new
			begin
				@client = Mysql2::Client.new(:host => @agent[:options][:host], :username => @agent[:options][:username] , :password => @agent[:options][:password] , :database => @agent[:options][:database])
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][SQLDetector] failed to load database connection, #{e}"}
				puts "[i2x][SQLDetector] failed to load database connection, #{e}"
			end

			# Execute Agent query on SQL database, check if content has been seen before
			#
			begin
				@client.query(@agent[:options][:query]).each(:symbolize_keys => false) do |row|
					unless @agent[:options][:content_id].nil? then
						@response = Cashier.verify row[@agent[:options][:content_id]], @agent, row
					else
						@response = Cashier.verify row["id"], @agent, row
					end
				end
			rescue Exception => e
				@response = {:status => 404, :message => "[i2x][SQLDetector] failed to load data from database, #{e}" }	
				puts "[i2x][SQLDetector] failed to load data from database, #{e}"
			end

			# Update agent checkup timestamp
			#
			begin
				@agent[:last_check_at] = @help.datetime
				@agent.save
			rescue Exception => e
				@response = {:status => 405, :message => "[i2x][SQLDetector] failed to update Agent metadata, #{e}"}
				puts "[i2x][SQLDetector] failed to update Agent metadata, #{e}"
			end

			@response
		end
	end
end