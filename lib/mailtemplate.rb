require 'delivery'
require 'slog'
require 'mail'

module Services
  class MailTemplate < Delivery

    public

    ##
    # => Performs the actual delivery, in this case, send email.
    #
    def execute
      Services::Slog.debug({:message => "Sending email for #{@template[:identifier]}", :module => "MailTemplate", :task => "execute", :extra => {:template => @template[:identifier], :payload => @template[:payload]}})
      
      begin

        Mail.defaults do
          delivery_method :smtp, :address => ENV["MAIL_ADDRESS"], :port => ENV["MAIL_PORT"], :domain => ENV["MAIL_DOMAIN"], :user_name => ENV["MAIL_USERNAME"], :password => ENV["MAIL_PASSWORD"], :authentication => ENV["MAIL_AUTHENTICATION"], :enable_starttls_auto => ENV["MAIL_STARTTLS"]
        end

        mail = Mail.new
        mail.from = ENV['MAIL_FROM']
        mail.to = @template[:payload][:to]
        mail.subject = "[i2x] #{@template[:payload][:subject]}"
        mail.bcc = @template[:payload][:bcc]
        mail.cc = @template[:payload][:cc]
        mail.content_type = 'text/html; charset=UTF-8'
        mail.body = "#{@template[:payload][:message]}<br /><br />Message sent automatically by <a href=\"https://bioinformatics.ua.pt/i2x/\">i2x</a> platform"

        mail.deliver

      rescue Exception => e
        Services::Slog.exception e
        response = { :status => "400", :message => "Unable to send email, #{e}"  }
      end
      response = { :status => "200", :message => "Email sent to #{@template[:payload][:to]}", :id =>  @template[:identifier]}            
    end


    ##
    # => Validates the server connection properties
    #
    def validate_properties
      true
    end
  end

end