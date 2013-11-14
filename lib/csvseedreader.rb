require 'slog'
require 'csv'

module Services

  # = CSVSeedReader
  #
  # Load content from CSV seed.
  #
  class CSVSeedReader < SeedReader
    ##
    # == Read
    #
    # => Load the seed data into the @objects array for processing.
    #
    def read
      begin
        CSV.new(open(@seed[:payload][:uri]), :headers => :first_row).each do |row|
          begin
            object = @help.deep_copy @agent[:payload]
            object.each_pair do |key,value|
              variables = @help.identify_variables(object[key])
              variables.each do |v|
                object[key].gsub!("%{#{v}}", row[@seed[:payload][:selectors][v].to_i])
              end
            end
            
            unless @seed[:payload][:cache].nil? then
            	object[:seed] = row[@seed[:payload][:cache].to_i]
            else
            	object[:seed] = row[0]
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