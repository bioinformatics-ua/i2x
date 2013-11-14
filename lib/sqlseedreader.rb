require 'slog'
require 'mysql2'

module Services

  # = SQLSeedReader
  #
  # Load content from SQL seed.
  #
  class SQLSeedReader < SeedReader
    ##
    # == Read
    #
    # => Load the seed data into the @objects array for processing.
    #
    def read
      begin
        @client = Mysql2::Client.new(:host => @seed[:payload][:host], :username => @seed[:payload][:username] , :password => @seed[:payload][:password] , :database => @seed[:payload][:database])
        @client.query(@seed[:payload][:query], :cast => false).each(:symbolize_keys => false) do |row|          
          begin
          	object = @help.deep_copy @agent[:payload]
            object.each_pair do |key,value|
              variables = @help.identify_variables(object[key])
              variables.each do |v|
                object[key].gsub!("%{#{v}}", row[@seed[:payload][:selectors][v]].to_str)
              end
            end
       
            unless @seed[:payload][:cache].nil? then
              object[:seed] = row[@seed[:payload][:cache]]
            else
              object[:seed] = row["id"]
            end
            object[:identifier] = @agent.identifier
            @objects.push object
          rescue Exception => e
            Services::Slog.exception e
          end
        end
      rescue Exception => e
        Services::Slog.exception e
      end
      
      @objects
    end
  end
end