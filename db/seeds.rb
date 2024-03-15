
p "destroying all Seed!"
Emergency.destroy_all
Schedule.destroy_all
Worker.destroy_all
Message.destroy_all
Chatroom.destroy_all
Hospital.destroy_all
User.destroy_all


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

schedule1 = Schedule.new(worker1: worker1, worker2: worker2, user: ambulancia1, active: true, current_lat: -23.53929282113, current_lon: -46.65384091724)
schedule1.save!
schedule2 = Schedule.new(worker1: worker3, worker2: worker4, user: ambulancia2, active: true, current_lat: -23.60028302147, current_lon: -46.64309817497)
schedule2.save!
schedule3 = Schedule.new(worker1: worker5, worker2: worker6, user: ambulancia3, active: true, current_lat: -23.608856, current_lon: -46.715081)
schedule3.save!
schedule4 = Schedule.new(worker1: worker7, worker2: worker8, user: ambulancia4, active: true, current_lat: -23.5380547, current_lon: -46.7056035)
schedule4.save!

hospital01 = Hospital.create!(name: "Le Wagon Hospital", latitude: -23.55195, longitude: -46.68898)
hospital02 = Hospital.create!(name: "Hospital São Paulo", latitude: -23.56334, longitude: -46.65454)
hospital03 = Hospital.create!(name: "Hospital das Clínicas", latitude: -23.56063, longitude: -46.72899)
hospital04 = Hospital.create!(name: "Hospital Albert Einstein", latitude: -23.58829, longitude: -46.66477)
hospital05 = Hospital.create!(name: "Hospital Sírio-Libanês", latitude: -23.55984, longitude: -46.67787)
hospital06 = Hospital.create!(name: "Hospital Israelita Albert Sabin", latitude: -23.55414, longitude: -46.65555)





emergency1 = Emergency.new({ n_people: 1, gravity: 8, category: 3, street: 'Rua Jericó 193, São Paulo - São Paulo, 05435-040, Brasil', neighborhood: 'Pinheiros', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.551826, emergency_lon:-46.6894, user: central, schedule: schedule1, description: "Acidente de trânsito envolvendo múltiplos veículos em rodovia movimentada, requerendo resposta urgente e coordenação eficaz dos serviços de emergência.", hospital: hospital01})
emergency1.save!
emergency2 = Emergency.new({ n_people: 2, gravity: 16, category: 1, street: 'Rua Apinajés 200, São Paulo - São Paulo, 05017-000, Brasil', neighborhood: 'Perdizes', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.533192, emergency_lon:-46.67713, user: central, schedule: schedule2, description: 'Desabamento parcial de edifício residencial, demandando resgate imediato de vítimas e avaliação estrutural para evitar riscos adicionais', hospital: hospital01})
emergency2.save!
emergency3 = Emergency.new({ n_people: 1, gravity: 18, category: 4, street: 'Avenida Paulista 1300, São Paulo - São Paulo, 01310-100, Brasil', neighborhood: 'Bela Vista', city: 'São Paulo', time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.563842, emergency_lon:-46.653326, user: central, schedule: schedule3, description: 'Paciente do sexo masculino apresentando sintomas compatíveis com infarto agudo do miocárdio, necessitando intervenção médica urgente para minimizar complicações cardíacas', hospital: hospital01})
emergency3.save!
emergency4 = Emergency.new({ n_people: 1, gravity: 7, category: 10, street: 'Avenida Do Estado 200, São Paulo - São Paulo, 01107-000, Brasil', neighborhood: 'Cambuci', city: 'São Paulo',time_start: DateTime.now.to_formatted_s(:db), emergency_lat:-23.564691, emergency_lon:-46.611123, user: central, schedule: schedule4, description: 'Criança manifestando sinais leves de reação alérgica, requerendo avaliação médica para determinar a causa e providenciar tratamento adequado visando seu bem-estar.'})
emergency4.save!





chatroom = Chatroom.create!(name: "general")


message1 = Message.create!(content:"Ocorrência 1: Paciente mulher de 60 anos acidentada ao lado da calçada após uma queda. Local: Rua jerico 193", chatroom: chatroom, user: central)
message2 = Message.create!(content:"Ocorrência 2: Dois pacientes homens feridos em um acidente de carro", chatroom: chatroom, user: central)

p "finalizando o seed"
