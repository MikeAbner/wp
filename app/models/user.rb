class User
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :fb_id,             type: String
  field :fb_token,          type: String
  field :first_name,        type: String
  field :last_name,         type: String
  field :last_logged_in_at, type: DateTime
  field :timestamps
  
  validates_presence_of :fb_id, :fb_token, :first_name, :last_name
end
