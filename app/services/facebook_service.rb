class FacebookService
  def self.post_activity_to_wall user, activity
    fb_user = FbGraph::User.new( user['fb_id'], :access_token => user['fb_token'] )
    post = fb_user.feed!(
      :message => "I just added the activity '#{activity.what}' to The Wanderphiles!",
      #:picture => 'https://graph.facebook.com/matake/picture',
      :link => "http://www.wanderphiles.com/activities/#{activity.id}",
      :name => 'The Wanderphiles',
      :description => 'The Wanderphiles is the place to record and share the things you do'
    )
    # for some reason the graph object id is nil. need to figure out how to deal with that...
    post.graph_object_id
  end
end