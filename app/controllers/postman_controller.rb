require 'helper'
require 'delivery'
require 'sqltemplate'
require 'filetemplate'
require 'urltemplate'

class PostmanController < ApplicationController
	def deliver

		@delivery

		begin
			case params[:publisher]
				when 'sql'
					@delivery = Services::SQLTemplate.new(params[:identifier], params[:publisher])
				when 'file'
					@delivery = Services::FileTemplate.new(params[:identifier], params[:publisher])
				when 'url'
					@delivery = Services::URLTemplate.new(params[:identifier], params[:publisher])
			end
		rescue Exception => e
			@response = { :status => "401", :message => "[i2x] Unable to load selected Delivery Template", :identifier => params[:identifier], :publisher => params[:publisher], :error => e }
		end

		begin
			@delivery.process params
		rescue Exception => e
			@response = { :status => "402", :message => "[i2x] Unable to process input parameters", :identifier => params[:identifier], :publisher => params[:publisher], :error => e, :template => @template }
		end

		begin
			@response = @delivery.execute
		rescue Exception => e
			@response = { :status => "403", :message => "[i2x] Unable to perform final delivery, #{e}", :identifier => params[:identifier], :publisher => params[:publisher], :error => e, :template => @template }
		end
		
		respond_to do |format|	
			format.json  { 
				render :json => @response    		
			}	
			format.js  { 
				render :json => @response    		
			}
			format.xml  { 
				render :xml => @response    		
			}
		end
	end

	def load
		begin
			@t = Template.where(identifier: params[:identifier], publisher: params[:publisher])
			if @t.count > 0 then
				response = { :status => "402", :message => "[i2x]: template #{params[:identifier]} already exists"}
			else 
				attrs = JSON.parse(IO.read("templates/#{params[:publisher]}/#{params[:identifier]}.js"))
				t = Template.create! attrs
				response = { :status => "200", :message => "[i2x]: template #{params[:identifier]} loaded", :id => "#{t[:id]}" }
			end			
		rescue
			response = { :status => "401", :message => "Error: template not found for #{params[:publisher]} with name #{params[:key]}.", :error =>  $!}
		end

		respond_to do |format|			
			format.json  { 
				render :json => response    		
			}		
			format.xml {
				render :xml => response
			}
			format.js  { 
				render :json => response    		
			}	
		end
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

		t = Template.find_by identifier: params[:identifier]
		
		if t[:publisher] == 'sql' then
	 		@lol = t[:payload][:host] #[:method]
	 	else 
	 		@lol = t[:payload][:uri]
	 	end
	 end
	end
