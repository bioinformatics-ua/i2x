require 'slog'
require 'mysql2'
require 'pg'

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

        case @seed[:payload][:server]
          when 'mysql'
            @client = Mysql2::Client.new(:host => @seed[:payload][:host], :username => @seed[:payload][:username], :password => @seed[:payload][:password], :database => @seed[:payload][:database])
            @client.query(@seed[:payload][:query], :cast => false).each(:symbolize_keys => false) do |row|
              begin
                object = @help.deep_copy @agent[:payload]
                object.each_pair do |key, value|
                  variables = @help.identify_variables(@seed[:payload][:key])
                  variables.each do |v|
                    @seed[:payload][:key].gsub!("%{#{v}}", row[@seed[:payload][:selectors][v]].to_str)
                  end
                end

                unless @seed[:payload][:cache].nil? then
                  @seed[:payload][:seed] = row[@seed[:payload][:cache]]
                else
                  @seed[:payload][:seed] = row["id"]
                end
                @seed[:payload][:identifier] = @agent.identifier
                @objects.push object
              rescue Exception => e
                Services::Slog.exception e
              end
            end
            @client.close
          when 'postgresql'
            client = PG::Connection.new(:host => @seed[:payload][host], :user => @seed[:payload][:username], :password => @seed[:payload][:password], :dbname => @seed[:payload][:database])
            client.exec(@seed[:payload][:query]).each do |row|
              begin
                object = @help.deep_copy @agent[:payload]
                object.each_pair do |key, value|
                  variables = @help.identify_variables(@seed[:payload][:key])
                  variables.each do |v|
                    @seed[:payload][:key].gsub!("%{#{v}}", row[@seed[:payload][:selectors][v]].to_str)
                  end
                end

                unless @seed[:payload][:cache].nil? then
                  @seed[:payload][:seed] = row[@seed[:payload][:cache]]
                else
                  @seed[:payload][:seed] = row["id"]
                end
                @seed[:payload][:identifier] = @agent.identifier
                @objects.push object
              rescue Exception => e
                Services::Slog.exception e
              end
            end
        end
      rescue Exception => e
        Services::Slog.exception e
      end


      @objects
    end
  end
end