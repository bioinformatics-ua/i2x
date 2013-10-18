class DeliveryController < ApplicationController
	
	def go
	end

	def get
		@response = params
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

	def post
		@response = params
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
end
