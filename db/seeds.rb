# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

u = User.new(:email => "admin@gmail.com", :password => "qweqwe")
u.role = "admin"
u.activated = true
u.locked = false
u.save!

u = User.new(:email => "test@gmail.com", :password => "qweqwe")
u.role = "student"
u.activated = true
u.locked =false
s = Student.new(:school => "NTU", :graduation_year => 1234, :majors => "Math", :nationality => "Singaporean")
s.save!
u.student = s
u.save!

puts "you have created an admin user [admin@gmail.com] with password qweqwe"


  