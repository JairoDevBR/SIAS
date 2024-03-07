p "starting the Seed!"

emergency1 = Emergency.new({ n_people: 1, category: 1, description: 'Paciente mulher acidentada ao lado da calçada', street: 'Rua jerico 193', neighborhood: 'Vila madalena', city: 'São Paulo' })
emergency1.save!
emergency2 = Emergency.new({ n_people: 2, category: 2, description: 'Dois pacientes homens feridos em um acidente de carro', street: 'Rua apinajes 200', neighborhood: 'Perdizes', city: 'São Paulo' })
emergency2.save!
emergency3 = Emergency.new({ n_people: 2, category: 3, description: 'Paciente mulher acidentada ao lado da calçada', street: 'avenida paulista 1300', neighborhood: 'bela vista', city: 'São Paulo' })
emergency3.save!

p "finalizando o seed"
