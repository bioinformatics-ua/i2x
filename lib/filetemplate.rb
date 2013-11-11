require 'delivery'
require 'raven'
require 'rails_config'

module Services
  class FileTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, execure SQL query.
    #
    def execute
      case @template[:payload][:method]
      when 'create'
        begin
          @template[:payload][:uri]["file://"] = ''
          #puts @template[:payload][:uri]
          File.open(@template[:payload][:uri], "w") { |file| file.write("\n") }
          response = { :status => "200", :message => "File created.", :id =>  @template[:payload][:uri]}

          unless @template[:payload][:content].nil?
            File.open(@template[:payload][:uri], "w") { |file| file.write(@template[:payload][:content]) }
          end
        rescue Exception => e
          if Settings.log.sentry then
            Raven.capture_exception(e)
          end
          response = { :status => "400", :message => "Method not is unsupported, #{e}"  }
        end
      when 'append'
        begin
          @template[:payload][:uri]["file://"] = ''
          unless @template[:payload][:content].nil?
            File.open(@template[:payload][:uri], "a") { |file| file.write(@template[:payload][:content]) }
          end
          response = { :status => "200", :message => "Content appended to file", :id =>  @template[:payload][:uri]}
        rescue Exception => e
          response = { :status => "403", :message => "Error processing file, #{e}" }
          if Settings.log.sentry then
            Raven.capture_exception(e)
          end
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