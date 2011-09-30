Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['WP_FACEBOOK_KEY'], ENV['WP_FACEBOOK_SECRET'], {:scope => "publish_stream"}
end