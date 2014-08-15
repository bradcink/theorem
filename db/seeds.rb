# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

admin = User.new(
  email: 'bradcink@auburn.edu',
  first_name: 'Brad', 
  last_name: 'Cink', 
  roles: ['admin'], 
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"]
)

new_user = User.new(
  email: 'graceanncink@gmail.com',
  first_name: 'Grace Ann', 
  last_name: 'Cink', 
  roles: ['admin'], 
  password: ENV["SEED_PASSWORD"],
  password_confirmation: ENV["SEED_PASSWORD"]
)

admin.skip_confirmation!
admin.save!
new_user.save!