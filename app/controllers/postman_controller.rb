class PostmanController < ApplicationController
	def deliver
		@key = params[:key]
	end

	def action
		begin
			template = JSON.parse(IO.read('templates/sql/bttf.js'))
		rescue
			response = { :status => "401", :message => "Error: template not found for #{params[:type]} with name #{params[:key]}." }
		end

		if params[:type] == 'sql' then
			# connect to database
			client = Mysql2::Client.new(:host => template['payload']['host'], :username => template['payload']['username'] , :password => template['payload']['password'] , :database => template['payload']['database'] )
			# update query with POST params
			template['payload']['query']['#{title}'] = params[:title]
			template['payload']['query']['#{description}'] = params[:description]

			# execute query
			result = client.query(template['payload']['query'])
			if client.last_id > 0 then
				response = { :status => "200", :message => "BTTF entry added: #{params[:title]}", :id => client.last_id, :payload => "{ 'info': 'yeps" + template['payload']['host'] + "''}" }
			end
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

end
