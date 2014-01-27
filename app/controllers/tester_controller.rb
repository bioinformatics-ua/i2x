require 'detector'
require 'sqldetector'
require 'xmldetector'
require 'csvdetector'
require 'helper'
require 'dropbox_sdk'
#require 'regexp'

class TesterController < ApplicationController


  def agent
    @d = Services::SQLDetector.new params[:identifier]
    @response = @d.checkup

    @response.merge({:content => "[i2x]: testing agent #{params[:identifier]}", :agent_id => @d.agent[:identifier]})
    respond_to do |format|
      format.json { render :json => @response }
      format.js { render :json => @response }
      format.xml { render :xml => @response }
    end
  end

  def regex
    # yarr = Array.new
    #str = 'abc %{i2x.map(title,{"a":2,"b":2, "c":3})};'
    a = 3
    str = 'ahlbsjdkfskdjfs${i2x.code(%{number} > 4 ? " yes " : " no " )}sdfdsf'
    str['%{number}'] = a.to_s
    fin = str.clone
    #yarr.push str

    #@help = Services::Helper.new
    arr = Array.new
    #@response = @help.process_functions str
    # processing code function
    str.scan(/\${i2x.code\((.*?)\)}/).each { |l|
      l.each { |m|
        #eval(m)
        fin["${i2x.code(#{m})}"] = eval(m).to_s
        puts "\n\tHERE: #{m}"
        #arr.push m
      }
    }

    @response = {}
    @response[:origin] = str
    @response[:end] = fin
=begin
    arr.each do |e|
      e.each do |entry|
        list = entry.to_str.split(',', 2)
        #@response = list
        @response[:identifier] = list.first
        @response[:map] = JSON.parse(list.last)
      end
    end
=end

    respond_to do |format|
      format.json { render :json => @response }
      format.js { render :json => @response }
      format.xml { render :xml => @response }
    end

  end

  def dropbox
    begin
      auth = Authorization.where(:provider => 'dropbox_oauth2').first
      client = DropboxClient.new(auth.token)

      file = open('data/agents/sql.js')
      response = client.put_file('/csv.js', file, true)

      @response = response.inspect
    rescue Exception => e
      Services::Slog.exception e
    end

    respond_to do |format|
      format.json { render :json => @response }
      format.js { render :json => @response }
      format.xml { render :xml => @response }
    end
  end

end