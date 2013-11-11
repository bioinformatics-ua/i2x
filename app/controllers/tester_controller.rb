require 'detector'
require 'sqldetector'
require 'xmldetector'
require 'csvdetector'
require 'helper'

class TesterController < ApplicationController

  def agent
    @d = Services::SQLDetector.new params[:identifier]
    @response = @d.checkup

    @response.merge({ :content => "[i2x]: testing agent #{params[:identifier]}", :agent_id => @d.agent[:identifier]})
    respond_to do |format|
      format.json { render :json => @response}
      format.js { render :json => @response}
      format.xml { render :xml => @response}
    end
  end

  def regex
    yarr = Array.new
    str =  "INSERT INTO stds(label, help, visited, created_at, updated_at) VALUES('variant', '%{refseq}:%{variant}', %{id}, now(), now());"
    yarr.push str

    @help = Services::Helper.new

    @response = @help.identify_variables yarr
    respond_to do |format|
      format.json { render :json => @response}
      format.js { render :json => @response}
      format.xml { render :xml => @response}
    end

  end

end