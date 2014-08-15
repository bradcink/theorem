class Friendship
  include Mongoid::Document
  belongs_to :user
  has_and_belongs_to_many :friends, :class_name => 'User'
  field :user_id, type: Integer
  field :friend_id, type: Integer
end
