class User
  include Mongoid::Document
  
  field :fb_id,       type: String
  field :fb_token,    type: String
  field :first_name,  type: String
  field :last_name,   type: String
end
