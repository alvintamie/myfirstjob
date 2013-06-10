# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.new(:email => "alvintamie@gmail.com", :password => "admin1234")
u.role = "admin"
u.activated = true
u.locked = false
u.save!

puts "you have created an admin user [admin@2359media.com] with password [admin2359]"
