require 'spec_helper'

describe UserService do
  describe 'find_or_create_by_facebook_id' do
    before(:each) do
      @app = FbGraph::Application.new( FB_APP_ID, :secret => FB_SECRET )
      @app.test_users.collect( &:destroy )
    end
    it 'should create a new user' do
      fb_user = @app.test_user!(:installed => true, :permissions => :read_stream)
      fb_user = fb_user.fetch
      
      user = nil
      expect {
        user = UserService.find_or_create_by_facebook_id( fb_user.identifier, fb_user.access_token )
      }.to change { User.count }.by 1
      
      user = JSON.parse( user )
      user.should_not be_nil
      user['_id'].should_not be_blank
      
      u = User.where( :fb_id => fb_user.identifier ).one
      u.should_not be_nil
      u.first_name.should == fb_user.first_name
      u.last_name.should == fb_user.last_name
    end
    it 'should update an existing user' do
      fb_user = @app.test_user!(:installed => true, :permissions => :read_stream)
      
      user = UserService.find_or_create_by_facebook_id( fb_user.identifier, fb_user.access_token )
      user = JSON.parse( user )
      
      u = nil
      expect {
        u = UserService.find_or_create_by_facebook_id( user['fb_id'], user['fb_token'] )
      }.to change { User.count }.by 0
      
      u = JSON.parse( u )
      u.should_not be_nil
      u['_id'].should_not be_blank
      
      u['_id'].should         == user['_id']
      u['fb_id'].should       == user['fb_id']
      u['fb_token'].should    == user['fb_token']
      u['first_name'].should  == user['first_name']
      u['last_name'].should   == user['last_name']
    end
    it 'should fail if no first name is returned from facebook'
    it 'should fail if no last name is returned from facebook'
  end
  
  describe 'login!' do
    before(:each) do
      @app = FbGraph::Application.new( FB_APP_ID, :secret => FB_SECRET )
      @app.test_users.collect( &:destroy )
      @fb_user = @app.test_user!(:installed => true, :permissions => :read_stream)
      @user = UserService.find_or_create_by_facebook_id( fb_user.identifier, fb_user.access_token )
      @user = JSON.parse( user )
    end
    it 'should set the last_logged_in_at field to now' do
      @user.last_logged_in_at.should be_blank
      
      UserService.login!( @user['_id'] )
      
      @user.last_logged_in_at.should_not be_blank
    end
  end
end