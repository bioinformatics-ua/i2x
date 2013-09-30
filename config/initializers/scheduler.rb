require 'rubygems'
require 'rufus/scheduler'
require 'mysql2'
require 'CSV'
require 'net/http'
require 'socket'

scheduler = Rufus::Scheduler.start_new


scheduler.every '10m' do
  # propogate!(mutex)
    #puts 'Hello Dave!'
    #dt = Time.new
    #CSV.open('data/log.csv', 'a') do |csv|
    #  csv << [dt.to_time, 'checked']
    #end
    checkup
    #puts Rails.configuration.host
  end

  def checkup
    client = Mysql2::Client.new(:host => 'localhost', :username => 'root' , :password => 'telematica' , :database => 'i2x')
    client.query('SELECT * FROM variants;').each(:symbolize_keys => true) do |row|
    results = Std.where visited: row[:id], label: 'variant'
      #results = client.query("SELECT * FROM stds WHERE label LIKE 'variant' AND visited = #{row[:id]};")
      if results.size == 0 then
        response = Net::HTTP.post_form(URI.parse("#{Rails.configuration.host}postman/variant.json"), { 'type' => 'sql', 'id' => row[:id], 'refseq' => row[:refseq], 'variant' => row[:variant]})

        #client.query("INSERT INTO stds(label, help, visited) VALUES('variant', '#{row[:refseq]}:#{row[:variant]}', #{row[:id]});")
        warn "Not found, adding #{row[:id]}..."
      else
        #results.each do |std|
        #  puts "#{std.id} integrated at #{std.created_at}"
        #end
      end
      dt = Time.new
      CSV.open('data/log.csv', 'a') do |csv|
        csv << [dt.to_time, 'variant', row[:id]]
      end
    end
  end


# Schedule repeating events.

#%w[2m 5m 10m 30m 1h 2h 5h 12h 1d 2d 7d].each do |schedule|
#  scheduler.every schedule do
    # run_schedule "every_#{schedule}", mutex
#  end
#end

# Schedule events for specific times.

# Times are assumed to be in PST for now.  Can store a user#timezone later.
#24.times do |hour|
#  scheduler.cron "0 #{hour} * * * America/Los_Angeles" do
#    if hour == 0
#      run_schedule "midnight", mutex
#    elsif hour < 12
#      run_schedule "#{hour}am", mutex
#    elsif hour == 12
#      run_schedule "noon", mutex
#    else
#      run_schedule "#{hour - 12}pm", mutex
#    end
#  end
#end

#scheduler.join