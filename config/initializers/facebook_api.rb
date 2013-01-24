if Rails.env.development?
  FB_APP_ID = ""
  FB_SECRET = ""
elsif Rails.env.test?
  FB_APP_ID = ""
  FB_SECRET = ""
elsif Rails.env.production?
  FB_APP_ID = ENV['FB_APP_ID']
  FB_SECRET = ENV['FB_SECRET']
end
