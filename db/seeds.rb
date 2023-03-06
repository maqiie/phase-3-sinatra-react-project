puts "🌱 Seeding spices..."

# Seed your database here
users1 =User.create(email:"mark@gmail.com")
users2 =User.create(email:"paul@gmail.com")
users3 =User.create(email:"mwenda@gmail.com")
users4 =User.create(email:"muthaura@gmail.com")

Project.create(title:"react app",description:"create a react app that works with the backend")
Project.create(title:"react app",description:"create a database app that works with the backend")
Project.create(title:"react app",description:"create a ruby app" )
Project.create(title:"react app",description:"create a react app that works with the frontend")


puts "✅ Done seeding!"
