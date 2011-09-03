if Rails.env.development?
  FB_APP_ID = "167725063305571"
  FB_SECRET = "29179ba2836119847c619d980fcf056a"
elsif Rails.env.test?
  FB_APP_ID = "167725063305571"
  FB_SECRET = "29179ba2836119847c619d980fcf056a"
elsif Rails.env.production?
  FB_APP_ID = ENV['FB_APP_ID']
  FB_SECRET = ENV['FB_SECRET']
end