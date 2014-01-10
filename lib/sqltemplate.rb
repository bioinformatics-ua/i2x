require 'delivery'
require 'raven'


module Services
  class SQLTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, execure SQL query.
    #
    def execute
      begin
        case @template[:payload][:server]
        when 'mysql'
          client = Mysql2::Client.new(:host => @template[:payload][:host], :username => @template[:payload][:username] , :password => @template[:payload][:password], :database => @template[:payload][:database] )
          result = client.query @template[:payload][:query]
          if client.last_id > 0 then
            response = { :status => "200", :message => "SQL Query successfully executed", :id => client.last_id}
          end
          client.close
        when 'sqlserver'
          response = { :status => "400", :message => "SQL Server is unsupported" }
        end
      rescue Exception => e
        if ENV["LOG_SENTRY"] then
          Raven.capture_exception(e)
        end
      end
      response
    end
    #handle_asynchronously :execute


    ##
    # => Validates the server connection properties
    #
    def validate_properties
      begin
        if @template[:payload][:server].nil? then
          @template[:payload][:server] = 'mysql'
        end
        
        if @template[:payload][:host].nil? then
          @template[:payload][:host] = 'localhost'
        end
        
        
        case @template[:payload][:server]
        when 'mysql'
          if (@template[:payload][:host].nil?) then
            @template[:payload][:port] = '3306'
          end
        when 'sqlserver'
          if (@template[:payload][:host].nil?) then
            @template[:payload][:port] = '0'
          end
        end
      rescue Exception => e
        if ENV["LOG_SENTRY"] then
          Raven.capture_exception(e)
        end
      end

    end
  end

end