# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


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

emergency1 = Emergency.new({ n_people: 1, gravity: 8, category: 3, description: 'Paciente mulher de 60 anos acidentada ao lado da calçada após uma queda', street: 'Rua jerico 193', neighborhood: 'Vila madalena', city: 'São Paulo', user_id: 2})
emergency1.save!
emergency2 = Emergency.new({ n_people: 2, gravity: 16, category: 1, description: 'Dois pacientes homens feridos em um acidente de carro', street: 'Rua apinajes 200', neighborhood: 'Perdizes', city: 'São Paulo', user_id: 2})
emergency2.save!
emergency3 = Emergency.new({ n_people: 1, gravity: 18, category: 4, description: 'Homem com sintomas de infarto', street: 'avenida paulista 1300', neighborhood: 'bela vista', city: 'São Paulo', user_id: 2})
emergency3.save!
emergency4 = Emergency.new({ n_people: 1, gravity: 7, category: 10, description: 'crianca com sintomas leves de alergia', street: 'avenida paulista 1300', neighborhood: 'bela vista', city: 'São Paulo', user_id: 2})
emergency4.save!

chatroom = Chatroom.create!(name: "general")

p "finalizando o seed"
