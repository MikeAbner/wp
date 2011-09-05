class UserService
  def self.find id
    user = User.find( id )
    
    user.to_json
  end
  
  def self.login! id
    user = User.find( id )
    user.last_logged_in_at = DateTime.now
    user.save
  end
  
  def self.find_or_create_by_facebook_id uid, access_token
    user = User.where( :fb_id => uid ).one

    if user.nil?
      user = UserService.create_user( uid, access_token )
    else
      UserService.update_user( user, access_token )
    end

    user.to_json
  end
  
private
  def self.create_user uid, access_token
    fb_user = FbGraph::User.new( uid, :access_token => access_token )
    fb_user = fb_user.fetch

    user = User.create( :fb_id      => uid,
                        :fb_token   => access_token,
                        :first_name => fb_user.first_name,
                        :last_name  => fb_user.last_name
                      )
    user
  end
  
  def self.update_user user, access_token
    fb_user = FbGraph::User.new( user.fb_id, :access_token => access_token )
    fb_user = fb_user.fetch

    user.fb_token   = access_token
    user.first_name = fb_user.first_name
    user.last_name  = fb_user.last_name
    
    user.save
  end
end