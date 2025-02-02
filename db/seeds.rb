# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

role = Role.create!(name: 'admin')
user = User.create(name: 'Foo', login: 'admin', password: 'Admin1234')
user.add_role(role)

['Mendoza', 'Buenos Aires', "Cordoba"].each do |prov|
  Province.create!(name: prov)
end
