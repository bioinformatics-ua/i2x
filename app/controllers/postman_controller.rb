require 'helper'
require 'delivery'
require 'sqltemplate'
require 'filetemplate'
require 'urltemplate'
require 'mailtemplate'
require 'dropboxtemplate'
require 'raven'

class PostmanController < ApplicationController
  def deliver
    Services::Slog.debug({:message => "Starting delivery for #{params[:identifier]}", :module => "Postman", :task => "deliver", :extra => {:template => params[:identifier], :params => params}})

    @delivery
    begin
      @template = Template.find_by! identifier: params[:identifier]
      

      case @template[:publisher]
      when 'sql'
        @delivery = Services::SQLTemplate.new @template
      when 'file'
        @delivery = Services::FileTemplate.new @template
      when 'url'
        @delivery = Services::URLTemplate.new @template
      when 'mail'
        @delivery = Services::MailTemplate.new @template
      when 'dropbox'
        @delivery = Services::DropboxTemplate.new @template
      end
    rescue Exception => e
      @response = { :status => "401", :message => "[i2x] Unable to load selected Delivery Template", :identifier => params[:identifier], :error => e }
      Services::Slog.exception e
    end

    begin
      @delivery.process params
    rescue Exception => e
      @response = { :status => "402", :message => "[i2x] Unable to process input parameters", :identifier => params[:identifier], :error => e, :template => @template }
      Services::Slog.exception e
    end

    begin
      @response = @delivery.execute
    rescue Exception => e
      @response = { :status => "403", :message => "[i2x] Unable to perform final delivery, #{e}", :identifier => params[:identifier], :error => e, :template => @template }
      Services::Slog.exception e
    end

    begin
      @template = nil
      @template = Template.find_by! identifier: params[:identifier]
      @template.increment(:count)
      @template.last_execute_at = Time.now
      @template.save
    rescue Exception => e
      Services::Slog.exception e
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
      Services::Slog.exception e
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