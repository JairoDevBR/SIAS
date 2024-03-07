# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "iniciando seed"
ambulancia = User.new(email: "ambulancia1@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia.save!

central = User.new(email: "central1@email.com", admin: "false", central: "true", password: '123123')
central.save!

admin = User.new(email: "admin1@email.com", admin: "true", central: "false", password: '123123')
admin.save!
puts "finalizando seed"
