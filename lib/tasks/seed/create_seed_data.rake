namespace :seed do
  desc "Erase and fill database"
  task :create_seed_data => :environment do

    [Comment,
     CompanyDetail,
     Employer,
     Event,
     Job,
     Student,
     Testimonial,
     User,
    ].each do |tbl|
      tbl.delete_all
      ActiveRecord::Base.connection.reset_pk_sequence!(tbl.table_name)
    end

    u = User.new(:email => "alvintamie@gmail.com", :password => "admin1234")
    u.role = "admin"
    u.activated = true
    u.locked = false
    u.save!

    EVENT_COUNT = 13
    Event.populate EVENT_COUNT do |event|
      event.title = Populator.words(1).titleize
      event.content = Populator.sentences(1..4)
      event.status = ["pending", "approved"]
    end

    Event.all.each do |event|
      event.update_attributes(:image => File.open("public/#{%w(event_1 event_2 event_3).sample}.jpeg"))
    end


    USER_COUNT = 3
    count = 1
    User.populate USER_COUNT do |user| 
      user.email = Faker::Internet.email
      user.first_name = Faker::Name.first_name
      user.last_name = Faker::Name.last_name
      user.locked = false
      user.activated = true
      user.role = ["employer", "student"]

      if user.role == "employer"
        employer = Employer.new
        employer.company_name = Faker::Company.name
        employer.company_type = Employer::TYPES.sample
        employer.address = Faker::Address.street_name + " " + Faker::Address.state + " " + Faker::Address.postcode
        employer.user_id = user.id
        employer.save

        CompanyDetail.populate 3 do |company_detail|
          company_detail.company_name = Faker::Company.name
          company_detail.company_industry = CompanyDetail::INDUSTRIES
          company_detail.company_type = CompanyDetail::TYPES
          company_detail.address = Faker::Address.street_name + " " + Faker::Address.state + " " + Faker::Address.postcode
          company_detail.number_of_employees = CompanyDetail::NUMBER_OF_EMPLOYEES
          company_detail.telephone = Faker::PhoneNumber.phone_number
          company_detail.fax = Faker::PhoneNumber.phone_number
          company_detail.contact_email = Faker::Internet.email
          company_detail.about = Populator.sentences(1..10)
          company_detail.award = Populator.sentences(1..6)
          company_detail.opportunities = Populator.sentences(1..4)
          company_detail.status = CompanyDetail::STATUS
          company_detail.employer_id = employer.id
          company_detail.created_at = 3.months.ago..Time.now
        end

        Job.populate 4 do |job|
          job = Job.new
          job.title = Populator.words(1..5).titleize
          job.location = Faker::Address.street_name + " " + Faker::Address.state + " " + Faker::Address.postcode
          job.date_posted = 7.months.ago..Time.now
          job.deadline = Time.now..4.months.from_now
          job.start_date = Time.now..5.months.from_now
          job.end_date = Time.now..12.months.from_now
          job.responsibility = Populator.sentences(5..15)
          job.requirements = Populator.sentences(5..8)
          job.job_type = Job::JOB_TYPE
          job.industry = Job::JOB_INDUSTRY
          job.job_scope = Job::JOB_SCOPE
          job.salary = 1000..6000
          job.number_of_hires = 2..10
          job.status = Job::STATUS
          job.employer_id = employer.id
          job.created_at = 3.months.ago..Time.now
        end
      elsif user.role == "student"
        #if student
        student = Student.new
        student.school = Student::SCHOOLS.sample
        student.graduation_year = Time.now..3.years.from_now
        student.majors = Populator.words(1..5).titleize
        student.nationality = Student::NATIONALITIES.sample
        student.user_id = user.id
        student.save


        CompanyDetail.populate 2 do |company_detail|
          company_detail.company_name = Faker::Company.name
          company_detail.company_industry = CompanyDetail::INDUSTRIES
          company_detail.company_type = CompanyDetail::TYPES
          company_detail.address = Faker::Address.street_name + " " + Faker::Address.state + " " + Faker::Address.postcode
          company_detail.number_of_employees = CompanyDetail::NUMBER_OF_EMPLOYEES
          company_detail.telephone = Faker::PhoneNumber.phone_number
          company_detail.fax = Faker::PhoneNumber.phone_number
          company_detail.contact_email = Faker::Internet.email
          company_detail.about = Populator.sentences(1..10)
          company_detail.award = Populator.sentences(1..6)
          company_detail.opportunities = Populator.sentences(1..4)
          company_detail.status = CompanyDetail::STATUS
          company_detail.student_id = student.id
          company_detail.created_at = 3.months.ago..Time.now
        end

        company_detail_ids = CompanyDetail.all.map{|c| c.id}

        Testimonial.populate 4 do |testimonial|
          testimonial.position = Populator.words(1..4).titleize
          testimonial.grade = Testimonial::GRADES
          testimonial.anonymous = [true,false]
          testimonial.votes = -10..50
          contents = Hash.new
          contents["culture"] = Populator.sentences(1..10) 
          contents["work_balance"] = Populator.sentences(1..10)
          contents["work_experience"] = Populator.sentences(1..10)
          contents["advice"] = Populator.sentences(1..10)
          testimonial.contents = contents
          testimonial.company_detail_id = 1..5
          testimonial.student_id = student.id
        end


        testimonial_ids = Testimonial.all.map{|t| t.id}
        Comment.populate 5 do |comment|
          comment.user_id = user.id
          comment.content = Populator.sentences(1..4)
          comment.testimonial_id = 1..9
        end
      end
      count += 1
      puts count
    end
    count = 0
    User.all.each do |user|
      user.update_attributes(:password => "qweqwe", :profile_image => File.open("public/#{(1..6).to_a.map{|a| "profile_image_" + a.to_s}.sample}.jpeg"))
      count += 1
      puts "update user image " + count.to_s
    end
    User.last.update_attributes(:email => "a@gmail.com")

    count = 0
    CompanyDetail.all.each do |company_detail|
      company_detail.update_attributes(:image => File.open("public/#{(1..10).to_a.map{|a| "employer_image_" + a.to_s}.sample}.jpeg"))
      count += 1
      puts "update company detail image" + count.to_s
    end
  end

end
