require 'spec_helper'

describe SessionsController do
  describe 'create' do
    before(:each) do
      @app = FbGraph::Application.new( FB_APP_ID, :secret => FB_SECRET )
      @app.test_users.collect( &:destroy )
    end
    it 'should log in a new user' do
      fb_user = @app.test_user!( :installed => true, :permissions => :read_stream )
      
      params = { :uid => fb_user.identifier, :access_token => fb_user.access_token }
      
      expect { post :create, params }.to change { User.count }.by 1
      
      session['user_id'].should_not be_blank
    end
    it 'should log in an existing user' do
      fb_user = @app.test_user!( :installed => true, :permissions => :read_stream )
      user = UserService.find_or_create_by_facebook_id( fb_user.identifier, fb_user.access_token )
      user = JSON.parse( user )
      
      params = { :uid => fb_user.identifier, :access_token => fb_user.access_token }
      
      expect { post :create, params }.to change { User.count }.by 0
      
      session['user_id'].should == user['_id']
    end
  end
end