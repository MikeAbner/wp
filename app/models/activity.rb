class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :owner_id,          type: String
  field :title,             type: String
  field :occurred_on,       type: Date
  field :with,              type: Array
  field :description,       type: String
  field :post_to_facebook,  type: Boolean
  field :wall_post_id,      type: String
  
  validates_presence_of :title, :occurred_on, :description
end
