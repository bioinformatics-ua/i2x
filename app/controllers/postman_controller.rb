require "helper"
require "template"

class PostmanController < ApplicationController
	def deliver
		@key = params[:key]
	end

	def action
		begin
			template = JSON.parse(IO.read("templates/sql/#{params[:key]}.js"))
			# puts "Template loaded for #{params[:key]}"
		rescue
			response = { :status => "401", :message => "Error: template not found for #{params[:type]} with name #{params[:key]}." }
		end

		if params[:type] == 'sql' then
			# connect to database
			client = Mysql2::Client.new(:host => template['payload']['host'], :username => template['payload']['username'] , :password => template['payload']['password'] , :database => template['payload']['database'] )
			# update query with POST params
			template['payload']['properties'].each do |prop|
				#puts "i2x property processed: #{prop} at " + template['payload']['query'][prop]
				template['payload']['query']["%{#{prop}}"] = params[prop]	
			end
			
			#template['payload']['query']['#{variant}'] = params[:variant]
			#template['payload']['query']['#{refseq}'] = params[:refseq]

			# execute query
			result = client.query(template['payload']['query'])
			if client.last_id > 0 then
				response = { :status => "200", :message => "Variant entry added: #{params[:id]}", :id => client.last_id, :payload => "{ 'info': 'yeps " + template['payload']['host'] + "''}" }
			end
			client.close
		else
			response = { :status => "404", :message => "Error: template not implemented for #{params[:type]}." }
		end

		respond_to do |format|			
			format.json  { 
				render :json => response    		
			}		
			format.xml {
				render :xml => response
			}
		end
		
	end

	def go
		@host = Services::Helper.hostname
		@date = Services::Helper.date
		@time = Services::Helper.datetime

		t = Template.first
		#attrs = JSON.parse(IO.read("templates/file/dump.js"))
		#t = Template.create! attrs
		#j = t[:payload].symbolize_keys!
	 	
	 	#o = ActiveSupport::JSON.decode(t[:payload]).symbolize_keys!
	 	#t.symbolize #[:payload] = t[:payload].symbolize_keys!
		@lol = t[:payload][:method]
	end

end
