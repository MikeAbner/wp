class Activity
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :owner_id,          type: String
  field :what,              type: String
  field :when,              type: Date
  field :where,             type: String  #the place
  field :in,                type: String  #the city/town/local
  field :with,              type: Array
  field :desc,              type: String
  field :fb_post,           type: Boolean
  field :fb_post_id,        type: String
  
  validates_presence_of :what, :when, :desc
  
  def self.for user, offset=0
    any_of( { owner_id: user['_id'] }, { 'with.in' => user['fb_id'] } ).desc( :when, :created_at ).offset( offset ).limit( 5 ).all
  end
end
