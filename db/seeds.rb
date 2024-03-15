# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
p "destroying all Seed!"
Schedule.destroy_all
Worker.destroy_all
Message.destroy_all
Chatroom.destroy_all
Emergency.destroy_all
User.destroy_all
# # DÁ ERROR PQ OS USERS CRIADOS SEM DROPAR O DATABASE POSSUEM ACIMA DE ID:4
require 'date'


p "starting the Seed!"
ambulancia1 = User.new(email: "ambulancia1@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia1.save!
central = User.new(email: "central1@email.com", admin: "false", central: "true", password: '123123')
central.save!
admin = User.new(email: "admin1@email.com", admin: "true", central: "false", password: '123123')
admin.save!
ambulancia2 = User.new(email: "ambulancia2@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia2.save!
ambulancia3 = User.new(email: "ambulancia3@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia3.save!
ambulancia4 = User.new(email: "ambulancia4@email.com", admin: "false", central: "false", kind: 1, plate: "ABC-1234", password: '123123')
ambulancia4.save!

worker1 = Worker.create(name: 'Guilherme Marques', occupation: 'paramedic')
worker1.save!
worker2 = Worker.create(name: 'Keny Chun', occupation: 'paramedic')
worker2.save!
worker3 = Worker.create(name: 'Jairo', occupation: 'paramedic')
worker3.save!
worker4 = Worker.create(name: 'Rebeca', occupation: 'paramedic')
worker4.save!
worker5 = Worker.create(name: 'Joao', occupation: 'paramedic')
worker5.save!
worker6 = Worker.create(name: 'Pedro', occupation: 'paramedic')
worker6.save!
worker7 = Worker.create(name: 'Mario', occupation: 'paramedic')
worker7.save!
worker8 = Worker.create(name: 'Jose', occupation: 'paramedic')
worker8.save!

schedule1 = Schedule.new(worker1_id: 1, worker2_id: 2, user_id: 1, active: true, current_lat: -23.53929282113, current_lon: -46.65384091724)
schedule1.save!
schedule2 = Schedule.new(worker1_id: 3, worker2_id: 4, user_id: 4, active: true, current_lat: -23.60028302147, current_lon: -46.64309817497)
schedule2.save!
schedule3 = Schedule.new(worker1_id: 5, worker2_id: 6, user_id: 5, active: true, current_lat: -23.608856, current_lon: -46.715081)
schedule3.save!
schedule4 = Schedule.new(worker1_id: 7, worker2_id: 8, user_id: 6, active: true, current_lat: -23.5380547, current_lon: -46.7056035)
schedule4.save!

emergency1 = Emergency.new({ n_people: 1, gravity: 8, category: 3, street: 'Rua Jericó 193, São Paulo - São Paulo, 05435-040, Brasil', neighborhood: 'Pinheiros', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.551826, emergency_lon:-46.6894, user_id: 1, schedule_id: 1, description: 'Paciente mulher de 60 anos acidentada ao lado da calçada após uma quedaHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infarto',})
emergency1.save!
emergency2 = Emergency.new({ n_people: 2, gravity: 16, category: 1, street: 'Rua Apinajés 200, São Paulo - São Paulo, 05017-000, Brasil', neighborhood: 'Perdizes', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.533192, emergency_lon:-46.67713, user_id: 2, schedule_id: 2, description: 'Dois pacientes homens feridos em um acidente de carroHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infarto'})
emergency2.save!
emergency3 = Emergency.new({ n_people: 1, gravity: 18, category: 4, street: 'Avenida Paulista 1300, São Paulo - São Paulo, 01310-100, Brasil', neighborhood: 'Bela Vista', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.563842, emergency_lon:-46.653326, user_id: 2, schedule_id: 3, description: 'Homem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infarto'})
emergency3.save!
emergency4 = Emergency.new({ n_people: 1, gravity: 7, category: 10, street: 'Avenida Do Estado 200, São Paulo - São Paulo, 01107-000, Brasil', neighborhood: 'Cambuci', city: 'São Paulo',time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.564691, emergency_lon:-46.611123, user_id: 2, schedule_id: 4, description: 'crianca com sintomas leves de alergiaHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infartoHomem com sintomas de infarto'})
emergency4.save!


chatroom = Chatroom.create!(name: "general")

message1 = Message.create!(content:"Ocorrência 1: Paciente mulher de 60 anos acidentada ao lado da calçada após uma queda. Local: Rua jerico 193", chatroom_id:1, user_id: 2)
message2 = Message.create!(content:"Ocorrência 2: Dois pacientes homens feridos em um acidente de carro", chatroom_id:1, user_id: 2)

p "finalizando o seed"
stock1 = Stock.create(tesoura: 3, luvas: 8, pinça: 2, esparadrapo: 6, alcool: 2, gaze_esterilizada: 4, atadura: 10, bandagens: 10, medicamentos_basicos: 10, user_id: 1)
stock1.save!
