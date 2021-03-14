# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_role = Role.create!(name: 'admin')
Role.create!(name: 'administrative')
Role.create!(name: 'seller')


user = User.create!(name: 'God', login: 'admin', password: '12345678', enabled: true)
user.add_roles(:admin)
