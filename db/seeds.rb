# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# p "destroying all Seed!"
# Schedule.destroy_all
# Worker.destroy_all
# Message.destroy_all
# Chatroom.destroy_all
# Emergency.destroy_all
# User.destroy_all
# DÁ ERROR PQ OS USERS CRIADOS SEM DROPAR O DATABASE POSSUEM ACIMA DE ID:4

p "starting the Seed!"
ambulancia = User.new(email: "ambulancia1@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia.save!

central = User.new(email: "central1@email.com", admin: "false", central: "true", password: '123123')
central.save!

admin = User.new(email: "admin1@email.com", admin: "true", central: "false", password: '123123')
admin.save!


worker1 = Worker.create(name: 'Guilherme Marques', occupation: 'paramedic')
worker1.save!
worker2 = Worker.create(name: 'Keny Chun', occupation: 'paramedic')
worker2.save!

emergency1 = Emergency.new({ n_people: 1, gravity: 8, category: 3, description: 'Paciente mulher de 60 anos acidentada ao lado da calçada após uma queda', street: 'Rua jerico 193', neighborhood: 'Vila madalena', city: 'São Paulo', emergency_lat:-23.551826, emergency_lon:-46.6894, user_id: 1})
emergency1.save!
emergency2 = Emergency.new({ n_people: 2, gravity: 16, category: 1, description: 'Dois pacientes homens feridos em um acidente de carro', street: 'Rua apinajes 200', neighborhood: 'Perdizes', city: 'São Paulo', emergency_lat:-23.533192, emergency_lon:-46.67713, user_id: 2})
emergency2.save!
emergency3 = Emergency.new({ n_people: 1, gravity: 18, category: 4, description: 'Homem com sintomas de infarto', street: 'avenida paulista 1300', neighborhood: 'bela vista', city: 'São Paulo', emergency_lat:-23.563842, emergency_lon:-46.653326, user_id: 2})
emergency3.save!
emergency4 = Emergency.new({ n_people: 1, gravity: 7, category: 10, description: 'crianca com sintomas leves de alergia', street: 'Avenida Do Estado 200, São Paulo - São Paulo, 01107-000, Brasil', neighborhood: 'Cambuci', city: 'São Paulo', emergency_lat:-23.564691, emergency_lon:-46.611123, user_id: 2})
emergency4.save!

schedule1 = Schedule.new(worker1_id: 1, worker2_id: 2, user_id: 1, active: true, current_lat: -23.539292, current_lon: -46.653840)
schedule1.save!
schedule2 = Schedule.new(worker1_id: 1, worker2_id: 2, user_id: 1, active: true, current_lat: -23.600283, current_lon: -46.643098)
schedule2.save!
schedule3 = Schedule.new(worker1_id: 1, worker2_id: 2, user_id: 1, active: true, current_lat: -23.608856, current_lon: -46.715081)
schedule3.save!

chatroom = Chatroom.create!(name: "general")

message1 = Message.create!(content:"Ocorrência 1: Paciente mulher de 60 anos acidentada ao lado da calçada após uma queda. Local: Rua jerico 193", chatroom_id:1, user_id: 2)
message2 = Message.create!(content:"Ocorrência 2: Dois pacientes homens feridos em um acidente de carro", chatroom_id:1, user_id: 2)

p "finalizando o seed"
