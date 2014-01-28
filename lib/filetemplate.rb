require 'delivery'
require 'slog'

module Services
  class FileTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, execute SQL query.
    #
    def execute
      Services::Slog.debug({:message => "File write for #{@template[:identifier]}", :module => "FileTemplate", :task => "execute", :extra => {:template => @template[:identifier], :payload => @template[:payload]}})
      case @template[:payload][:method]
      when 'create'
        begin
          
          @template.users.each do |user|
            File.open("data/users/#{user.id}/#{@template[:payload][:uri]}", "w+") { |file| file.write("\n") }
            response = { :status => "200", :message => "File created.", :id =>  @template[:payload][:uri]}

            unless @template[:payload][:content].nil? then
              File.open("data/users/#{user.id}/#{@template[:payload][:uri]}", "w+") { |file| file.write(@template[:payload][:content]) }
            end
          end
        rescue Exception => e
          Services::Slog.exception e
          response = { :status => "400", :message => "Method not is unsupported, #{e}"  }
        end
      when 'append'
        begin
         @template.users.each do |user|
          unless @template[:payload][:content].nil? then
            File.open(Dir.pwd + "/data/users/#{user.id}/#{@template[:payload][:uri]}", "a+") { |file| file.write(@template[:payload][:content]) }
          end
        end
        response = { :status => "200", :message => "Content appended to file", :id =>  @template[:payload][:uri]}
      rescue Exception => e
        response = { :status => "403", :message => "Error processing file, #{e}" }
        Services::Slog.exception e
      end
    end

    response
  end
    #handle_asynchronously :execute

    ##
    # => Validates the server connection properties
    #
    def validate_properties
      true
    end
  end

end