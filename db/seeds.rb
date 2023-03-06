puts "🌱 Seeding spices..."

# Seed your database here
users1 =User.create(email:"mark@gmail.com",password: "mark")
users2 =User.create(email:"paul@gmail.com",password: "paul")
users3 =User.create(email:"mwenda@gmail.com",password: "mwenda")
users4 =User.create(email:"muthaura@gmail.com",password: "muthaura")

Project.create(title:"react app",description:"create a react app that works with the backend")
Project.create(title:"java script app",description:"create a database app that works with the backend")
Project.create(title:"forex bot",description:"create a ruby app" )
Project.create(title:"delivery system",description:"create a react app that works with the frontend")


puts "✅ Done seeding!"
