class Activity
  include Mongoid::Document
  
  field :title,             type: String
  field :occurred_on,       type: Date
  field :description,       type: String
  field :post_to_facebook,  type: Boolean
  field :wall_post_id,      type: String
end
