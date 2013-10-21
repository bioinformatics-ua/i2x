require 'sqldetector'

@d = Services::SQLDetector.new 'agents_sql'

@d.checkup

#require 'ActiveSupport::JSON'

#json = IO.read('../templates/sql/variant.js')

#j = ActiveSupport::JSON

#obj = j.decode(json)

#puts obj[:type]