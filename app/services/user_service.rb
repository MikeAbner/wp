class UserService
  def self.find_or_create_by_facebook_id uid, access_token
    user = { :id => uid }
  end
end