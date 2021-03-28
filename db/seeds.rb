# coding: utf-8

User.create!(name: "管理者",
             email: "sample@email.com",
             password: "password",
             password_confirmation: "password",
             department: "管理者",
             employee_number: 0,
             card_ID: 0,
             admin: true) # 最初のユーザーのみadmin属性をtrueにする
             
User.create!(name: "上長A",
             email: "sample1@email.com",
             password: "password",
             password_confirmation: "password",
             department: "役員",
             employee_number: 0,
             card_ID: 0,)
             
User.create!(name: "上長B",
             email: "sample2@email.com",
             password: "password",
             password_confirmation: "password",
             department: "役員",
             employee_number: 0,
             card_ID: 0)
             
20.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password ="password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end
             
             