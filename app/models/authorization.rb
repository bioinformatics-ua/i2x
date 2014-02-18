class Authorization < ActiveRecord::Base
	belongs_to :user

	after_create :fetch_details

	##
	# => Load details from external services using custom API/gems.
	#
	def fetch_details
		self.send("fetch_details_from_#{self.provider.downcase}")
	end

	##
	# => Load user details from Facebook
	#
	def fetch_details_from_facebook
		# graph = Koala::Facebook::API.new(self.token)
		# facebook_data = graph.get_object("me")
		# self.username = facebook_data['username']
		# self.save
		# self.user.username = facebook_data['username'] if self.user.username.blank?
		# self.user.image = "http://graph.facebook.com/" + self.username + "/picture?type=large" if self.user.image.blank?
		# self.user.location = facebook_data['location'] if self.user.location.blank?
		# self.user.save
		self.user.has_facebook = true
		self.user.save
	end

	##
	# => Load user details from Twitter
	#
	def fetch_details_from_twitter
		# twitter_object = Twitter::Client.new(
		# 	:oauth_token => self.token,
		# 	:oauth_token_secret => self.secret
		# 	)
		# twitter_data = Twitter.user(self.uid.to_i)
		# self.username = twitter_data.username
		# self.save
		# self.user.username = twitter_data.username if self.user.username.blank?
		# self.user.image = twitter_data.profile_image_url if self.user.image.blank?
		# self.user.location = twitter_data.location if self.user.location.blank?
		# self.user.save(:validate => false)
		self.user.has_twitter = true
		self.user.save
	end

	##
	# => Load user details from GitHub
	#
	def fetch_details_from_github
		# To Do
		self.user.has_github = true
		self.user.save
	end

	##
	# => Load user details from LinkedIn
	#
	def fetch_details_from_linkedin
		# To Do
		self.user.has_linkedin = true
		self.user.save
	end

	##
	# => Load user details from Google Plus
	#
	def fetch_details_from_google_oauth2
		# To Do
		self.user.has_google = true
		self.user.save
	end

	##
	# => Load user details from Dropbox
	#
	def fetch_details_from_dropbox_oauth2
		# To Do
		self.user.has_dropbox = true
		self.user.save
	end	
end
