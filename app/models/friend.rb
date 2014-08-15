class Friend
  include Mongoid::Document
  belongs_to :friendship
  belongs_to :user
end
