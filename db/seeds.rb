require 'date'

# DATABASE OBTIDO PELO GPT

# exemplos de emergencias criado pelo GPT
# emergencias = [
#   {
#     description: "Vítima de acidente de trânsito com ferimentos graves. Motorista embriagado invadiu a pista contrária. Idade: 35 anos. Sem doenças pré-existentes.",
#     category: 1, # Acidentes de trânsito
#     gravity: 15, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Paciente com sintomas de infarto. Pressão arterial elevada e dor no peito há mais de 30 minutos. Idade: 60 anos. Diagnóstico prévio de hipertensão.",
#     category: 4, # Parada cardiorrespiratória
#     gravity: 18, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Criança com crise alérgica grave após picada de inseto. Inchaço severo e dificuldade respiratória. Idade: 10 anos. Sem doenças pré-existentes.",
#     category: 10, # Reações alérgicas graves
#     gravity: 12, # Gravidade média
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Idoso com histórico de problemas respiratórios em estado crítico. Insuficiência respiratória aguda e cianose. Idade: 80 anos. Diagnóstico prévio de enfisema pulmonar.",
#     category: 6, # Problemas respiratórios
#     gravity: 17, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa ferida por arma branca durante briga. Perfuração no abdômen e sangramento profuso. Idade: 28 anos. Sem doenças pré-existentes.",
#     category: 9, # Ferimentos por arma branca ou de fogo
#     gravity: 16, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Mulher grávida com complicações durante o parto. Sangramento vaginal intenso e dor abdominal. Idade: 32 anos. Diagnóstico prévio de pré-eclâmpsia.",
#     category: 8, # Complicações durante a gravidez ou parto
#     gravity: 19, # Gravidade muito alta
#     n_people: 2 # Duas pessoas afetadas (mãe e bebê)
#   },
#   {
#     description: "Vítima de queda de altura com suspeita de fraturas múltiplas. Inconsciente e hemorragia interna. Idade: 45 anos. Sem doenças pré-existentes.",
#     category: 3, # Ferimentos por queda
#     gravity: 14, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa inconsciente após intoxicação alimentar. Vômito persistente e sonolência extrema. Idade: 22 anos. Sem doenças pré-existentes.",
#     category: 5, # Intoxicação ou envenenamento
#     gravity: 13, # Gravidade média
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Ataque epiléptico em via pública. Convulsões recorrentes e dificuldade em respirar. Idade: 40 anos. Sem doenças pré-existentes.",
#     category: 2, # Mal súbito
#     gravity: 11, # Gravidade média-baixa
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Vítimas de acidente de trânsito múltiplo com ferimentos leves. Colisão em cadeia envolvendo três veículos. Idade: 25 anos. Sem doenças pré-existentes.",
#     category: 1, # Acidentes de trânsito
#     gravity: 10, # Gravidade média-baixa
#     n_people: 3 # Três pessoas afetadas
#   },
#   {
#     description: "Homem de 50 anos com fratura exposta após queda de andaime. Sangramento intenso e dor severa. Sem doenças pré-existentes.",
#     category: 3, # Ferimentos por queda
#     gravity: 16, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa de 28 anos com crise de asma grave. Dispneia extrema e uso de musculatura acessória. Sem doenças pré-existentes.",
#     category: 6, # Problemas respiratórios
#     gravity: 14, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Idoso de 70 anos com hemorragia digestiva alta. Vômito com sangue e pressão arterial baixa. Diagnóstico prévio de úlcera péptica.",
#     category: 5, # Intoxicação ou envenenamento
#     gravity: 18, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Mulher grávida de 28 anos com contrações regulares. Dor abdominal intensa e ruptura da bolsa amniótica. Sem doenças pré-existentes.",
#     category: 8, # Complicações durante a gravidez ou parto
#     gravity: 16, # Gravidade alta
#     n_people: 2 # Duas pessoas afetadas (mãe e bebê)
#   },
#   {
#     description: "Criança de 6 anos com convulsões febris. Rigidez muscular e perda de consciência. Sem doenças pré-existentes.",
#     category: 2, # Mal súbito
#     gravity: 13, # Gravidade média
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Vítima de atropelamento com trauma cranioencefálico grave. Perda de consciência e respiração irregular. Sem doenças pré-existentes.",
#     category: 1, # Acidentes de trânsito
#     gravity: 20, # Gravidade muito alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Jovem de 20 anos com dor torácica aguda. História familiar de doença cardíaca. Sem doenças pré-existentes.",
#     category: 4, # Parada cardiorrespiratória
#     gravity: 17, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa de 35 anos com intoxicação alimentar. Diarreia profusa e desidratação. Sem doenças pré-existentes.",
#     category: 5, # Intoxicação ou envenenamento
#     gravity: 11, # Gravidade média-baixa
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Homem de 45 anos com ferimento por arma branca na região do tórax. Hemorragia controlada e respiração dificultada. Sem doenças pré-existentes.",
#     category: 9, # Ferimentos por arma branca ou de fogo
#     gravity: 15, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Idoso de 75 anos com sintomas de AVC. Hemiparesia e fala arrastada. Sem doenças pré-existentes.",
#     category: 4, # Parada cardiorrespiratória
#     gravity: 19, # Gravidade muito alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Criança de 8 anos sofrendo de choque anafilático após ingestão de amendoim. Edema de língua e dificuldade respiratória. Sem doenças pré-existentes.",
#     category: 10, # Reações alérgicas graves
#     gravity: 16, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa de 50 anos com suspeita de fratura de coluna após queda de altura. Dor intensa na região lombar e incapacidade de movimento das pernas. Sem doenças pré-existentes.",
#     category: 3, # Ferimentos por queda
#     gravity: 18, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Idoso de 65 anos com queimaduras de segundo grau extensas após explosão em casa. Dor intensa e risco de infecção. Sem doenças pré-existentes.",
#     category: 11, # Outros
#     gravity: 17, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Mulher grávida de 30 anos com histórico de aborto espontâneo apresentando sangramento vaginal intenso. Dor abdominal e tontura. Sem doenças pré-existentes.",
#     category: 8, # Complicações durante a gravidez ou parto
#     gravity: 18, # Gravidade alta
#     n_people: 2 # Duas pessoas afetadas (mãe e bebê)
#   },
#   {
#     description: "Pessoa de 40 anos com asfixia por engasgamento com objeto estranho. Incapacidade de falar e respirar. Sem doenças pré-existentes.",
#     category: 11, # Outros
#     gravity: 15, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Criança de 5 anos com febre alta e convulsões febris. Estado convulsivo e inconsciência. Sem doenças pré-existentes.",
#     category: 2, # Mal súbito
#     gravity: 14, # Gravidade média-alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Homem de 55 anos sofrendo de hipoglicemia grave. Confusão mental e sudorese profusa. Diagnóstico prévio de diabetes mellitus.",
#     category: 11, # Outros
#     gravity: 16, # Gravidade alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Jovem de 18 anos com ferimentos por arma de fogo no tórax após tentativa de assalto. Hemorragia ativa e instabilidade hemodinâmica. Sem doenças pré-existentes.",
#     category: 9, # Ferimentos por arma branca ou de fogo
#     gravity: 19, # Gravidade muito alta
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Pessoa de 25 anos com ataque de ansiedade agudo em local público. Taquicardia e respiração rápida. Sem doenças pré-existentes.",
#     category: 11, # Outros
#     gravity: 12, # Gravidade média
#     n_people: 1 # Uma pessoa afetada
#   },
#   {
#     description: "Idoso de 70 anos com hemorragia gastrointestinal maciça devido a úlcera péptica perfurada. Sangramento ativo e estado de choque. Diagnóstico prévio de úlcera péptica.",
#     category: 11, # Outros
#     gravity: 20, # Gravidade muito alta
#     n_people: 1 # Uma pessoa afetada
#   }
# ]

# exemplos de localizacoes criado pelo GPT
localizacoes = [
  {
    "street": "Rua Augusta 1800, São Paulo - São Paulo, 01305-100, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.555108,
    "emergency_lon": -46.660889,
    "local_type": nil
  },
  {
    "street": "Rua Augusta 1800, São Paulo - São Paulo, 01305-100, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.555108,
    "emergency_lon": -46.660889,
    "local_type": nil
  },
  {
    "street": "Avenida Rebouças 2000, São Paulo - São Paulo, 05401-200, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.562438,
    "emergency_lon": -46.687547,
    "local_type": nil
  },
  {
    "street": "Rua Oscar Freire 900, São Paulo - São Paulo, 01426-001, Brasil",
    "neighborhood": "Jardins",
    "city": "São Paulo",
    "emergency_lat": -23.56796,
    "emergency_lon": -46.670344,
    "local_type": nil
  },
  {
    "street": "Avenida Paulista 1700, São Paulo - São Paulo, 01310-200, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.558944,
    "emergency_lon": -46.662809,
    "local_type": nil
  },
  {
    "street": "Rua da Consolação 1500, São Paulo - São Paulo, 01301-100, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.556778,
    "emergency_lon": -46.655425,
    "local_type": nil
  },
  {
    "street": "Avenida Brigadeiro Faria Lima 1800, São Paulo - São Paulo, 01452-001, Brasil",
    "neighborhood": "Itaim Bibi",
    "city": "São Paulo",
    "emergency_lat": -23.58096,
    "emergency_lon": -46.677414,
    "local_type": nil
  },
  {
    "street": "Rua Bela Cintra 1300, São Paulo - São Paulo, 01415-001, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.562142,
    "emergency_lon": -46.655953,
    "local_type": nil
  },
  {
    "street": "Avenida Angélica 1500, São Paulo - São Paulo, 01228-200, Brasil",
    "neighborhood": "Higienópolis",
    "city": "São Paulo",
    "emergency_lat": -23.540993,
    "emergency_lon": -46.663577,
    "local_type": nil
  },
  {
    "street": "Rua Haddock Lobo 1200, São Paulo - São Paulo, 01414-002, Brasil",
    "neighborhood": "Jardins",
    "city": "São Paulo",
    "emergency_lat": -23.56074,
    "emergency_lon": -46.655366,
    "local_type": nil
  },
  {
    "street": "Rua Estados Unidos 1700, São Paulo - São Paulo, 01427-002, Brasil",
    "neighborhood": "Jardins",
    "city": "São Paulo",
    "emergency_lat": -23.56617,
    "emergency_lon": -46.666464,
    "local_type": nil
  },
  {
    "street": "Rua Duque de Caxias 400, Guarulhos - São Paulo, 07012-040, Brasil",
    "neighborhood": "Centro",
    "city": "Guarulhos",
    "emergency_lat": -23.461044,
    "emergency_lon": -46.527014,
    "local_type": nil
  },
  {
    "street": "Avenida dos Autonomistas 500, Osasco - São Paulo, 06020-012, Brasil",
    "neighborhood": "Centro",
    "city": "Osasco",
    "emergency_lat": -23.531759,
    "emergency_lon": -46.766511,
    "local_type": nil
  },
  {
    "street": "Rua Dona Primitiva Vianco 600, Barueri - São Paulo, 06401-050, Brasil",
    "neighborhood": "Jardim Silveira",
    "city": "Barueri",
    "emergency_lat": -23.511591,
    "emergency_lon": -46.874744,
    "local_type": nil
  },
  {
    "street": "Avenida Papa João Paulo I 700, Mauá - São Paulo, 09371-540, Brasil",
    "neighborhood": "Centro",
    "city": "Mauá",
    "emergency_lat": -23.665494,
    "emergency_lon": -46.458444,
    "local_type": nil
  },
  {
    "street": "Rua José Monteiro de Oliveira 800, Santo André - São Paulo, 09050-430, Brasil",
    "neighborhood": "Vila Guiomar",
    "city": "Santo André",
    "emergency_lat": -23.663891,
    "emergency_lon": -46.525485,
    "local_type": nil
  },
  {
    "street": "Avenida Washington Luís 900, Diadema - São Paulo, 09911-160, Brasil",
    "neighborhood": "Centro",
    "city": "Diadema",
    "emergency_lat": -23.691059,
    "emergency_lon": -46.619079,
    "local_type": nil
  },
  {
    "street": "Rua Manoel Coelho 1000, São Bernardo do Campo - São Paulo, 09750-430, Brasil",
    "neighborhood": "Centro",
    "city": "São Bernardo do Campo",
    "emergency_lat": -23.694865,
    "emergency_lon": -46.565708,
    "local_type": nil
  },
  {
    "street": "Avenida Presidente Kennedy 1100, Mogi das Cruzes - São Paulo, 08773-250, Brasil",
    "neighborhood": "Vila Partênio",
    "city": "Mogi das Cruzes",
    "emergency_lat": -23.533801,
    "emergency_lon": -46.181632,
    "local_type": nil
  },
  {
    "street": "Rua Voluntários da Pátria 1200, Suzano - São Paulo, 08674-010, Brasil",
    "neighborhood": "Centro",
    "city": "Suzano",
    "emergency_lat": -23.544217,
    "emergency_lon": -46.310264,
    "local_type": nil
  },
  {
    "street": "Avenida Pereira Barreto 1300, Santo André - São Paulo, 09190-210, Brasil",
    "neighborhood": "Jardim Santo André",
    "city": "Santo André",
    "emergency_lat": -23.673183,
    "emergency_lon": -46.540541,
    "local_type": nil
  },
  {
    "street": "Avenida Armando de Andrade 1400, São Paulo - São Paulo, 02721-200, Brasil",
    "neighborhood": "Pirituba",
    "city": "São Paulo",
    "emergency_lat": -23.492228,
    "emergency_lon": -46.712611,
    "local_type": nil
  },
  {
    "street": "Rua Alcides de Queirós 1500, São Caetano do Sul - São Paulo, 09550-150, Brasil",
    "neighborhood": "Santa Maria",
    "city": "São Caetano do Sul",
    "emergency_lat": -23.625516,
    "emergency_lon": -46.570139,
    "local_type": nil
  },
  {
    "street": "Avenida Brasil 1600, Santo André - São Paulo, 09111-210, Brasil",
    "neighborhood": "Jardim do Estádio",
    "city": "Santo André",
    "emergency_lat": -23.651822,
    "emergency_lon": -46.507344,
    "local_type": nil
  },
  {
    "street": "Rua XV de Novembro 1700, São Bernardo do Campo - São Paulo, 09720-020, Brasil",
    "neighborhood": "Centro",
    "city": "São Bernardo do Campo",
    "emergency_lat": -23.68876,
    "emergency_lon": -46.548679,
    "local_type": nil
  },
  {
    "street": "Avenida Nova Cantareira 1800, São Paulo - São Paulo, 02330-001, Brasil",
    "neighborhood": "Tucuruvi",
    "city": "São Paulo",
    "emergency_lat": -23.466624,
    "emergency_lon": -46.61124,
    "local_type": nil
  },
  {
    "street": "Rua Duque de Caxias 1900, Guarulhos - São Paulo, 07012-040, Brasil",
    "neighborhood": "Centro",
    "city": "Guarulhos",
    "emergency_lat": -23.456708,
    "emergency_lon": -46.530914,
    "local_type": nil
  },
  {
    "street": "Avenida Lucas Nogueira Garcez 2000, Atibaia - São Paulo, 12940-000, Brasil",
    "neighborhood": "Vila Thais",
    "city": "Atibaia",
    "emergency_lat": -23.131695,
    "emergency_lon": -46.54718,
    "local_type": nil
  },
  {
    "street": "Rua Nove de Julho 2100, Barueri - São Paulo, 06414-005, Brasil",
    "neighborhood": "Jardim Belval",
    "city": "Barueri",
    "emergency_lat": -23.497332,
    "emergency_lon": -46.875239,
    "local_type": nil
  },
  {
    "street": "Avenida Humberto Alencar Castelo Branco 2200, Carapicuíba - São Paulo, 06340-490, Brasil",
    "neighborhood": "Vila Sul Americana",
    "city": "Carapicuíba",
    "emergency_lat": -23.527428,
    "emergency_lon": -46.837388,
    "local_type": nil
  },
  {
    "street": "Rua Coronel Ernesto de Oliveira 2300, São Paulo - São Paulo, 05795-020, Brasil",
    "neighborhood": "Vila São José",
    "city": "São Paulo",
    "emergency_lat": -23.643183,
    "emergency_lon": -46.754907,
    "local_type": nil
  },
  {
    "street": "Rua Vergueiro 1000, São Paulo - São Paulo, 04101-000, Brasil",
    "neighborhood": "Vila Mariana",
    "city": "São Paulo",
    "emergency_lat": -23.600351821392582,
    "emergency_lon": -46.624149772431615,
    "local_type": nil
  },
  {
    "street": "Avenida Rebouças 2000, São Paulo - São Paulo, 05401-200, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.553494277068705,
    "emergency_lon": -46.6790065748236,
    "local_type": nil
  },
  {
    "street": "Rua da Mooca 3000, São Paulo - São Paulo, 03165-000, Brasil",
    "neighborhood": "Mooca",
    "city": "São Paulo",
    "emergency_lat": -23.56748544934988,
    "emergency_lon": -46.593406839346564,
    "local_type": nil
  },
  {
    "street": "Avenida Sumaré 4000, São Paulo - São Paulo, 05428-000, Brasil",
    "neighborhood": "Perdizes",
    "city": "São Paulo",
    "emergency_lat": -23.53672369994583,
    "emergency_lon": -46.705071837983496,
    "local_type": nil
  },
  {
    "street": "Rua Haddock Lobo 5000, São Paulo - São Paulo, 01414-000, Brasil",
    "neighborhood": "Jardins",
    "city": "São Paulo",
    "emergency_lat": -23.565862504773136,
    "emergency_lon": -46.64928649333998,
    "local_type": nil
  },
  {
    "street": "Avenida Indianópolis 6000, São Paulo - São Paulo, 04086-002, Brasil",
    "neighborhood": "Moema",
    "city": "São Paulo",
    "emergency_lat": -23.59639988460375,
    "emergency_lon": -46.66147781376295,
    "local_type": nil
  },
  {
    "street": "Rua Voluntários da Pátria 7000, São Paulo - São Paulo, 02010-000, Brasil",
    "neighborhood": "Santana",
    "city": "São Paulo",
    "emergency_lat": -23.49043669876131,
    "emergency_lon": -46.64012210737793,
    "local_type": nil
  },
  {
    "street": "Avenida Engenheiro Caetano Álvares 8000, São Paulo - São Paulo, 02546-000, Brasil",
    "neighborhood": "Limão",
    "city": "São Paulo",
    "emergency_lat": -23.487191507959782,
    "emergency_lon": -46.686632357490296,
    "local_type": nil
  },
  {
    "street": "Rua Itapura 9000, São Paulo - São Paulo, 03310-000, Brasil",
    "neighborhood": "Tatuapé",
    "city": "São Paulo",
    "emergency_lat": -23.54578952608223,
    "emergency_lon": -46.58716128966772,
    "local_type": nil
  },
  {
    "street": "Avenida Aricanduva 10000, São Paulo - São Paulo, 03460-000, Brasil",
    "neighborhood": "Aricanduva",
    "city": "São Paulo",
    "emergency_lat": -23.597215242740354,
    "emergency_lon": -46.5043417801711,
    "local_type": nil
  },
  {
    "street": "Rua Curupaiti, 300 - Vila Romana, São Paulo - SP, 05072-010, Brasil",
    "neighborhood": "Vila Romana",
    "city": "São Paulo",
    "emergency_lat": -23.527919495258196,
    "emergency_lon": -46.663221785917194,
    "local_type": nil
  },
  {
    "street": "Rua Cipriano Barata, 750 - Ipiranga, São Paulo - SP, 04205-000, Brasil",
    "neighborhood": "Ipiranga",
    "city": "São Paulo",
    "emergency_lat": -23.570936756472513,
    "emergency_lon": -46.63229187197987,
    "local_type": nil
  },
  {
    "street": "Rua Bica de Pedra, 45 - Jardim Prudência, São Paulo - SP, 04378-040, Brasil",
    "neighborhood": "Jardim Prudência",
    "city": "São Paulo",
    "emergency_lat": -23.64483387509295,
    "emergency_lon": -46.632084031423105,
    "local_type": nil
  },
  {
    "street": "Rua Porto Martins, 171 - Vila Carrao, São Paulo - SP, 03444-130, Brasil",
    "neighborhood": "Vila Carrao",
    "city": "São Paulo",
    "emergency_lat": -23.543194544145155,
    "emergency_lon": -46.52928554613131,
    "local_type": nil
  },
  {
    "street": "Rua Rio Azul, 187 - Jardim dos Manacás, São Paulo - SP, 05754-100, Brasil",
    "neighborhood": "Jardim dos Manacás",
    "city": "São Paulo",
    "emergency_lat": -23.6809200720567,
    "emergency_lon": -46.74084827057864,
    "local_type": nil
  },
  {
    "street": "Rua Dona Lucrécia, 80 - Jardim Brasil, São Paulo - SP, 02226-010, Brasil",
    "neighborhood": "Jardim Brasil",
    "city": "São Paulo",
    "emergency_lat": -23.484326203337876,
    "emergency_lon": -46.58990083038099,
    "local_type": nil
  },
  {
    "street": "Rua das Pedras, 225 - Vila São José, São Paulo - SP, 02755-060, Brasil",
    "neighborhood": "Vila São José",
    "city": "São Paulo",
    "emergency_lat": -23.508476301307894,
    "emergency_lon": -46.682286014602816,
    "local_type": nil
  },
  {
    "street": "Rua dos Encanadores, 95 - Jardim Nordeste, São Paulo - SP, 03687-070, Brasil",
    "neighborhood": "Jardim Nordeste",
    "city": "São Paulo",
    "emergency_lat": -23.51347704643965,
    "emergency_lon": -46.533301030630014,
    "local_type": nil
  },
  {
    "street": "Rua Manuel Azevedo Fortes, 108 - Jardim Brasil, São Paulo - SP, 02228-040, Brasil",
    "neighborhood": "Jardim Brasil",
    "city": "São Paulo",
    "emergency_lat": -23.511439538418927,
    "emergency_lon": -46.54908813264484,
    "local_type": nil
  },
  {
    "street": "Rua Salvador Correia, 60 - Vila Santa Maria, São Paulo - SP, 08275-070, Brasil",
    "neighborhood": "Vila Santa Maria",
    "city": "São Paulo",
    "emergency_lat": -23.49874986061791,
    "emergency_lon": -46.456636054651284,
    "local_type": nil
  },
  {
    "street": "Rua Júlio César, 127 - Jardim Santa Cruz, São Paulo - SP, 04905-140, Brasil",
    "neighborhood": "Jardim Santa Cruz",
    "city": "São Paulo",
    "emergency_lat": -23.715420441621063,
    "emergency_lon": -46.70800848546441,
    "local_type": nil
  },
  {
    "street": "Rua Antônio Tomaz de Lima, 293 - Jardim Varginha, São Paulo - SP, 04857-020, Brasil",
    "neighborhood": "Jardim Varginha",
    "city": "São Paulo",
    "emergency_lat": -23.79974792690879,
    "emergency_lon": -46.69927228622202,
    "local_type": nil
  },
  {
    "street": "Rua Barros Alarcon, 35 - Jardim Itapema, São Paulo - SP, 03980-040, Brasil",
    "neighborhood": "Jardim Itapema",
    "city": "São Paulo",
    "emergency_lat": -23.602641689580334,
    "emergency_lon": -46.43111975320912,
    "local_type": nil
  },
  {
    "street": "Rua Joaquim Pinto de Oliveira, 267 - Jardim São João, São Paulo - SP, 08111-240, Brasil",
    "neighborhood": "Jardim São João",
    "city": "São Paulo",
    "emergency_lat": -23.50780780728208,
    "emergency_lon": -46.405039267870315,
    "local_type": nil
  },
  {
    "street": "Rua Domingos da Costa, 399 - Jardim das Palmeiras, São Paulo - SP, 04938-030, Brasil",
    "neighborhood": "Jardim das Palmeiras",
    "city": "São Paulo",
    "emergency_lat": -23.723998277918014,
    "emergency_lon": -46.747903157854935,
    "local_type": nil
  },
  {
    "street": "Rua José Benedito, 128 - Jardim Jaraguá, São Paulo - SP, 05183-020, Brasil",
    "neighborhood": "Jardim Jaraguá",
    "city": "São Paulo",
    "emergency_lat": -23.48576010944368,
    "emergency_lon": -46.76944617312694,
    "local_type": nil
  },
  {
    "street": "Rua Leonor Quadros, 55 - Jardim Patente Novo, São Paulo - SP, 04242-030, Brasil",
    "neighborhood": "Jardim Patente Novo",
    "city": "São Paulo",
    "emergency_lat": -23.643625929841203,
    "emergency_lon": -46.59059458225244,
    "local_type": nil
  },
  {
    "street": "Rua Manoel da Rocha Lino, 267 - Jardim São João, São Paulo - SP, 08111-220, Brasil",
    "neighborhood": "Jardim São João",
    "city": "São Paulo",
    "emergency_lat": -23.486029953067966,
    "emergency_lon": -46.44054426530251,
    "local_type": nil
  },
  {
    "street": "Rua Pedro de Góes, 119 - Jardim Novo Carrão, São Paulo - SP, 03445-080, Brasil",
    "neighborhood": "Jardim Novo Carrão",
    "city": "São Paulo",
    "emergency_lat": -23.549440323469856,
    "emergency_lon": -46.5116948881179,
    "local_type": nil
  },
  {
    "street": "Rua Raul Cardoso, 200 - Jardim São José, São Paulo - SP, 08121-600, Brasil",
    "neighborhood": "Jardim São José",
    "city": "São Paulo",
    "emergency_lat": -23.526582060346453,
    "emergency_lon": -46.411138678659995,
    "local_type": nil
  },
  {
    "street": "Rua Santa Ifigênia, 106 - Santa Ifigênia, São Paulo - SP, 01207-000, Brasil",
    "neighborhood": "Santa Ifigênia",
    "city": "São Paulo",
    "emergency_lat": -23.557449482137788,
    "emergency_lon": -46.650111772640905,
    "local_type": nil
  },
  {
    "street": "Rua Augusta, 1500 - Consolação, São Paulo - SP, 01305-000, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.565251963542572,
    "emergency_lon": -46.68521159538047,
    "local_type": nil
  },
  {
    "street": "Rua da Consolação, 2657 - Cerqueira César, São Paulo - SP, 01416-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.53043007615748,
    "emergency_lon": -46.65249223978878,
    "local_type": nil
  },
  {
    "street": "Rua Sena Madureira, 700 - Vila Mariana, São Paulo - SP, 04021-051, Brasil",
    "neighborhood": "Vila Mariana",
    "city": "São Paulo",
    "emergency_lat": -23.59480220745905,
    "emergency_lon": -46.60989505032481,
    "local_type": nil
  },
  {
    "street": "Rua Vergueiro, 1441 - Vila Mariana, São Paulo - SP, 04101-000, Brasil",
    "neighborhood": "Vila Mariana",
    "city": "São Paulo",
    "emergency_lat": -23.589649408459966,
    "emergency_lon": -46.66077485874377,
    "local_type": nil
  },
  {
    "street": "Rua Bela Cintra, 967 - Consolação, São Paulo - SP, 01415-003, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.56725763216141,
    "emergency_lon": -46.67756924097931,
    "local_type": nil
  },
  {
    "street": "Rua da Consolação, 3596 - Higienópolis, São Paulo - SP, 01246-001, Brasil",
    "neighborhood": "Higienópolis",
    "city": "São Paulo",
    "emergency_lat": -23.571956429285084,
    "emergency_lon": -46.64326513174855,
    "local_type": nil
  },
  {
    "street": "Rua Peixoto Gomide, 282 - Jardim Paulista, São Paulo - SP, 01409-000, Brasil",
    "neighborhood": "Jardim Paulista",
    "city": "São Paulo",
    "emergency_lat": -23.58239306935474,
    "emergency_lon": -46.67102111308824,
    "local_type": nil
  },
  {
    "street": "Rua Conselheiro Ramalho, 714 - Bela Vista, São Paulo - SP, 01325-000, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.526860915205237,
    "emergency_lon": -46.62729627108384,
    "local_type": nil
  },
  {
    "street": "Rua da Consolação, 300 - República, São Paulo - SP, 01301-000, Brasil",
    "neighborhood": "República",
    "city": "São Paulo",
    "emergency_lat": -23.531524448511924,
    "emergency_lon": -46.638820588812756,
    "local_type": nil
  },
  {
    "street": "Rua Fortunato, 62 - Vila Carrão, São Paulo - SP, 03445-020, Brasil",
    "neighborhood": "Vila Carrão",
    "city": "São Paulo",
    "emergency_lat": -23.56570209854784,
    "emergency_lon": -46.5132181928647,
    "local_type": nil
  },
  {
    "street": "Rua Alencar Araripe, 123 - Vila Liviero, São Paulo - SP, 04187-040, Brasil",
    "neighborhood": "Vila Liviero",
    "city": "São Paulo",
    "emergency_lat": -23.60559618106484,
    "emergency_lon": -46.59974807651482,
    "local_type": nil
  },
  {
    "street": "Rua Forte do Calvário, 89 - Vila Industrial, São Paulo - SP, 03274-160, Brasil",
    "neighborhood": "Vila Industrial",
    "city": "São Paulo",
    "emergency_lat": -23.565380621649467,
    "emergency_lon": -46.49324913818102,
    "local_type": nil
  },
  {
    "street": "Rua Marcial Lourenço Serodio, 279 - Vila Ema, São Paulo - SP, 03283-070, Brasil",
    "neighborhood": "Vila Ema",
    "city": "São Paulo",
    "emergency_lat": -23.55732813632831,
    "emergency_lon": -46.546390177371855,
    "local_type": nil
  },
  {
    "street": "Rua Francisco Antônio de Almeida, 90 - Vila Nova Cachoeirinha, São Paulo - SP, 02463-070, Brasil",
    "neighborhood": "Vila Nova Cachoeirinha",
    "city": "São Paulo",
    "emergency_lat": -23.4703884073759,
    "emergency_lon": -46.65994617651635,
    "local_type": nil
  },
  {
    "street": "Rua Joaquim Ferreira Silva, 158 - Jardim Itapura, São Paulo - SP, 08460-200, Brasil",
    "neighborhood": "Jardim Itapura",
    "city": "São Paulo",
    "emergency_lat": -23.62065228605044,
    "emergency_lon": -46.39202809007995,
    "local_type": nil
  },
  {
    "street": "Rua Francisca Silveira de Jesus, 10 - Jardim dos Pereiras, São Paulo - SP, 04966-100, Brasil",
    "neighborhood": "Jardim dos Pereiras",
    "city": "São Paulo",
    "emergency_lat": -23.732111221847195,
    "emergency_lon": -46.740946685124506,
    "local_type": nil
  },
  {
    "street": "Rua Catugi, 100 - Parque Maria Luiza, São Paulo - SP, 02112-070, Brasil",
    "neighborhood": "Parque Maria Luiza",
    "city": "São Paulo",
    "emergency_lat": -23.496432265844124,
    "emergency_lon": -46.603719328792295,
    "local_type": nil
  },
  {
    "street": "Rua Argeu Egídio dos Santos, 158 - Vila Antonieta, São Paulo - SP, 03474-160, Brasil",
    "neighborhood": "Vila Antonieta",
    "city": "São Paulo",
    "emergency_lat": -23.586276325970722,
    "emergency_lon": -46.485624652651914,
    "local_type": nil
  },
  {
    "street": "Rua Afonso Cavalcante, 22 - Vila Oratório, São Paulo - SP, 03191-040, Brasil",
    "neighborhood": "Vila Oratório",
    "city": "São Paulo",
    "emergency_lat": -23.611952140444778,
    "emergency_lon": -46.575012409788805,
    "local_type": nil
  },
  {
    "street": "Rua Hortência Amélia de Barros, 78 - Parque Boturussu, São Paulo - SP, 03804-090, Brasil",
    "neighborhood": "Parque Boturussu",
    "city": "São Paulo",
    "emergency_lat": -23.582936157798045,
    "emergency_lon": -46.462536502862214,
    "local_type": nil
  },
  {
    "street": "Rua José Gonçalves Xavier, 45 - Conjunto Residencial José Bonifácio, São Paulo - SP, 08255-070, Brasil",
    "neighborhood": "Conjunto Residencial José Bonifácio",
    "city": "São Paulo",
    "emergency_lat": -23.582771188787827,
    "emergency_lon": -46.392471788632626,
    "local_type": nil
  },
  {
    "street": "Rua Odorico Fonseca, 112 - Jardim Adelfiore, São Paulo - SP, 02996-120, Brasil",
    "neighborhood": "Jardim Adelfiore",
    "city": "São Paulo",
    "emergency_lat": -23.478914657348934,
    "emergency_lon": -46.76880192975164,
    "local_type": nil
  },
  {
    "street": "Rua Célio Augusto da Silva, 75 - Vila Diva (Zona Norte), São Paulo - SP, 02233-040, Brasil",
    "neighborhood": "Vila Diva (Zona Norte)",
    "city": "São Paulo",
    "emergency_lat": -23.470563238100276,
    "emergency_lon": -46.60821222969952,
    "local_type": nil
  },
  {
    "street": "Rua João Francisco Moura, 96 - Parque São Jorge, São Paulo - SP, 03087-060, Brasil",
    "neighborhood": "Parque São Jorge",
    "city": "São Paulo",
    "emergency_lat": -23.510174488122257,
    "emergency_lon": -46.57872001606956,
    "local_type": nil
  },
  {
    "street": "Rua José Cezário Faria, 20 - Vila Galvão, São Paulo - SP, 07074-301, Brasil",
    "neighborhood": "Vila Galvão",
    "city": "São Paulo",
    "emergency_lat": -23.479969354579502,
    "emergency_lon": -46.53140923148065,
    "local_type": nil
  },
  {
    "street": "Rua Major Frederico Hirsch, 68 - Jardim Matarazzo, São Paulo - SP, 03810-150, Brasil",
    "neighborhood": "Jardim Matarazzo",
    "city": "São Paulo",
    "emergency_lat": -23.514774463872676,
    "emergency_lon": -46.47516184689014,
    "local_type": nil
  },
  {
    "street": "Rua Júlio Ferraz de Almeida, 52 - Jardim Grimaldi, São Paulo - SP, 05734-230, Brasil",
    "neighborhood": "Jardim Grimaldi",
    "city": "São Paulo",
    "emergency_lat": -23.605701962089665,
    "emergency_lon": -46.724003083747,
    "local_type": nil
  },
  {
    "street": "Rua Professor Raul Briquet, 25 - Parque Peruche, São Paulo - SP, 02531-000, Brasil",
    "neighborhood": "Parque Peruche",
    "city": "São Paulo",
    "emergency_lat": -23.496036076147707,
    "emergency_lon": -46.63003113169418,
    "local_type": nil
  },
  {
    "street": "Rua Maria Tereza da Silva, 30 - Vila Carrão, São Paulo - SP, 03453-060, Brasil",
    "neighborhood": "Vila Carrão",
    "city": "São Paulo",
    "emergency_lat": -23.589186783192417,
    "emergency_lon": -46.52003710148288,
    "local_type": nil
  },
  {
    "street": "Rua João Álvares Soares, 155 - Campo Belo, São Paulo - SP, 04604-020, Brasil",
    "neighborhood": "Campo Belo",
    "city": "São Paulo",
    "emergency_lat": -23.612064968020068,
    "emergency_lon": -46.635151949801504,
    "local_type": nil
  },
  {
    "street": "Rua Hermantino Coelho, 104 - Jardim São Paulo, São Paulo - SP, 02042-050, Brasil",
    "neighborhood": "Jardim São Paulo",
    "city": "São Paulo",
    "emergency_lat": -23.47039413269792,
    "emergency_lon": -46.60075682992418,
    "local_type": nil
  },
  {
    "street": "Rua Dois de Julho, 69 - Vila Bertioga, São Paulo - SP, 03187-010, Brasil",
    "neighborhood": "Vila Bertioga",
    "city": "São Paulo",
    "emergency_lat": -23.53064749462659,
    "emergency_lon": -46.5713873568585,
    "local_type": nil
  },
  {
    "street": "Rua Custódio Vieira, 90 - Chácara Inglesa, São Paulo - SP, 04140-060, Brasil",
    "neighborhood": "Chácara Inglesa",
    "city": "São Paulo",
    "emergency_lat": -23.59555224759677,
    "emergency_lon": -46.6549243578901,
    "local_type": nil
  },
  {
    "street": "Rua Solimões, 380 - Jardim das Bandeiras, São Paulo - SP, 05454-040, Brasil",
    "neighborhood": "Jardim das Bandeiras",
    "city": "São Paulo",
    "emergency_lat": -23.57074562892227,
    "emergency_lon": -46.72793658069943,
    "local_type": nil
  },
  {
    "street": "Rua Mário Antunes da Silva, 115 - Jardim Ana Maria, São Paulo - SP, 03257-070, Brasil",
    "neighborhood": "Jardim Ana Maria",
    "city": "São Paulo",
    "emergency_lat": -23.60423364948334,
    "emergency_lon": -46.45085658497509,
    "local_type": nil
  },
  {
    "street": "Rua Luís Fidalgo, 78 - Parque Novo Mundo, São Paulo - SP, 02184-070, Brasil",
    "neighborhood": "Parque Novo Mundo",
    "city": "São Paulo",
    "emergency_lat": -23.518683279803884,
    "emergency_lon": -46.579006336102424,
    "local_type": nil
  },
  {
    "street": "Rua Vasco da Gama, 182 - Jardim Celeste, São Paulo - SP, 05541-030, Brasil",
    "neighborhood": "Jardim Celeste",
    "city": "São Paulo",
    "emergency_lat": -23.605696023465867,
    "emergency_lon": -46.765098138431306,
    "local_type": nil
  },
  {
    "street": "Rua Bento de Andrade, 345 - Jardim Paulista, São Paulo - SP, 04503-020, Brasil",
    "neighborhood": "Jardim Paulista",
    "city": "São Paulo",
    "emergency_lat": -23.59914787512021,
    "emergency_lon": -46.63660550658784,
    "local_type": nil
  },
  {
    "street": "Rua José Custódio da Silva, 112 - Vila Mariana, São Paulo - SP, 04051-040, Brasil",
    "neighborhood": "Vila Mariana",
    "city": "São Paulo",
    "emergency_lat": -23.581524658962515,
    "emergency_lon": -46.62658481104117,
    "local_type": nil
  },
  {
    "street": "Rua Voluntários da Pátria 1200, Suzano - São Paulo, 08674-010, Brasil",
    "neighborhood": "Centro",
    "city": "Suzano",
    "emergency_lat": -23.544217,
    "emergency_lon": -46.310264,
    "local_type": "hospital"
  },
  {
    "street": "Rua Dona Primitiva Vianco 600, Barueri - São Paulo, 06401-050, Brasil",
    "neighborhood": "Jardim Silveira",
    "city": "Barueri",
    "emergency_lat": -23.511591,
    "emergency_lon": -46.874744,
    "local_type": "pharmacy"
  },
  {
    "street": "Rua Alcides de Queirós 1500, São Caetano do Sul - São Paulo, 09550-150, Brasil",
    "neighborhood": "Santa Maria",
    "city": "São Caetano do Sul",
    "emergency_lat": -23.625516,
    "emergency_lon": -46.570139,
    "local_type": "fire_station"
  },
  {
    "street": "Rua Santa Ifigênia, 106 - Santa Ifigênia, São Paulo - SP, 01207-000, Brasil",
    "neighborhood": "Santa Ifigênia",
    "city": "São Paulo",
    "emergency_lat": -23.557449482137788,
    "emergency_lon": -46.650111772640905,
    "local_type": "police_station"
  },
  {
    "street": "Rua Manoel da Rocha Lino, 267 - Jardim São João, São Paulo - SP, 08111-220, Brasil",
    "neighborhood": "Jardim São João",
    "city": "São Paulo",
    "emergency_lat": -23.486029953067966,
    "emergency_lon": -46.44054426530251,
    "local_type": "grocery_or_supermarket"
  },
  {
    "street": "Rua José Monteiro de Oliveira 800, Santo André - São Paulo, 09050-430, Brasil",
    "neighborhood": "Vila Guiomar",
    "city": "Santo André",
    "emergency_lat": -23.663891,
    "emergency_lon": -46.525485,
    "local_type": "bank"
  },
  {
    "street": "Rua Rio Azul, 187 - Jardim dos Manacás, São Paulo - SP, 05754-100, Brasil",
    "neighborhood": "Jardim dos Manacás",
    "city": "São Paulo",
    "emergency_lat": -23.6809200720567,
    "emergency_lon": -46.74084827057864,
    "local_type": "school"
  },
  {
    "street": "Rua Conselheiro Ramalho, 714 - Bela Vista, São Paulo - SP, 01325-000, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.526860915205237,
    "emergency_lon": -46.62729627108384,
    "local_type": "park"
  },
  {
    "street": "Rua Salvador Correia, 60 - Vila Santa Maria, São Paulo - SP, 08275-070, Brasil",
    "neighborhood": "Vila Santa Maria",
    "city": "São Paulo",
    "emergency_lat": -23.49874986061791,
    "emergency_lon": -46.456636054651284,
    "local_type": "gas_station"
  },
  {
    "street": "Avenida Ipiranga, 200 - República, São Paulo - SP, 01046-010, Brasil",
    "neighborhood": "República",
    "city": "São Paulo",
    "emergency_lat": -23.545428,
    "emergency_lon": -46.644479,
    "local_type": "metro_station"
  },
  {
      "street": "Rua da Consolação, 233 - Consolação, São Paulo - SP, 01301-000, Brasil",
      "neighborhood": "Consolação",
      "city": "São Paulo",
      "emergency_lat": -23.555888,
      "emergency_lon": -46.659123,
      "local_type": "metro_station"
  },
  {
      "street": "Avenida Brigadeiro Faria Lima, 2277 - Jardim Paulistano, São Paulo - SP, 01452-000, Brasil",
      "neighborhood": "Jardim Paulistano",
      "city": "São Paulo",
      "emergency_lat": -23.570868,
      "emergency_lon": -46.695359,
      "local_type": "metro_station"
  },
  {
      "street": "Avenida Paulista, 1578 - Bela Vista, São Paulo - SP, 01310-200, Brasil",
      "neighborhood": "Bela Vista",
      "city": "São Paulo",
      "emergency_lat": -23.561958,
      "emergency_lon": -46.655980,
      "local_type": "metro_station"
  },
  {
      "street": "Rua Libero Badaró, 377 - Centro, São Paulo - SP, 01008-001, Brasil",
      "neighborhood": "Centro",
      "city": "São Paulo",
      "emergency_lat": -23.546891,
      "emergency_lon": -46.640618,
      "local_type": "metro_station"
  },
  {
      "street": "Avenida Vital Brasil, 1000 - Butantã, São Paulo - SP, 05503-001, Brasil",
      "neighborhood": "Butantã",
      "city": "São Paulo",
      "emergency_lat": -23.563258,
      "emergency_lon": -46.730536,
      "local_type": "metro_station"
  },
  {
      "street": "Rua Vergueiro, 2045 - Vila Mariana, São Paulo - SP, 04101-100, Brasil",
      "neighborhood": "Vila Mariana",
      "city": "São Paulo",
      "emergency_lat": -23.589254,
      "emergency_lon": -46.634379,
      "local_type": "metro_station"
  },
  {
      "street": "Avenida Jabaquara, 1711 - Mirandópolis, São Paulo - SP, 04045-000, Brasil",
      "neighborhood": "Mirandópolis",
      "city": "São Paulo",
      "emergency_lat": -23.617901,
      "emergency_lon": -46.640001,
      "local_type": "metro_station"
  },
  {
      "street": "Rua da Mooca, 339 - Mooca, São Paulo - SP, 03104-000, Brasil",
      "neighborhood": "Mooca",
      "city": "São Paulo",
      "emergency_lat": -23.558526,
      "emergency_lon": -46.595802,
      "local_type": "metro_station"
  },
  {
      "street": "Rua Augusta, 1948 - Cerqueira César, São Paulo - SP, 01412-000, Brasil",
      "neighborhood": "Cerqueira César",
      "city": "São Paulo",
      "emergency_lat": -23.561703,
      "emergency_lon": -46.668150,
      "local_type": "metro_station"
  },
  {
    "street": "Rua Augusta, 1371 - Consolação, São Paulo - SP, 01305-100, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.554131,
    "emergency_lon": -46.654173,
    "local_type": "restaurant"
  },
  {
    "street": "Rua Avanhandava, 32 - Bela Vista, São Paulo - SP, 01306-001, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.551547,
    "emergency_lon": -46.648577,
    "local_type": "restaurant"
  },
  {
    "street": "Rua Alameda Santos, 1123 - Jardim Paulista, São Paulo - SP, 01419-001, Brasil",
    "neighborhood": "Jardim Paulista",
    "city": "São Paulo",
    "emergency_lat": -23.567727,
    "emergency_lon": -46.654405,
    "local_type": "shopping_mall"
  },
  {
    "street": "Rua Haddock Lobo, 1738 - Cerqueira César, São Paulo - SP, 01414-003, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.564800,
    "emergency_lon": -46.667041,
    "local_type": "cafe"
  },
  {
    "street": "Rua Oscar Freire, 279 - Cerqueira César, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.565963,
    "emergency_lon": -46.670033,
    "local_type": "shopping_mall"
  },
  {
    "street": "Rua Joaquim Floriano, 466 - Itaim Bibi, São Paulo - SP, 04534-002, Brasil",
    "neighborhood": "Itaim Bibi",
    "city": "São Paulo",
    "emergency_lat": -23.582327,
    "emergency_lon": -46.672303,
    "local_type": "cafe"
  },
  {
    "street": "Avenida Brigadeiro Faria Lima, 2232 - Jardim Paulistano, São Paulo - SP, 01489-900, Brasil",
    "neighborhood": "Jardim Paulistano",
    "city": "São Paulo",
    "emergency_lat": -23.568098,
    "emergency_lon": -46.696219,
    "local_type": "shopping_mall"
  },
  {
    "street": "Rua Oscar Freire, 911 - Cerqueira César, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.562157,
    "emergency_lon": -46.668246,
    "local_type": "cafe"
  },
  {
    "street": "Rua Augusta, 225 - Consolação, São Paulo - SP, 01304-000, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.550148,
    "emergency_lon": -46.648103,
    "local_type": "cafe"
  },
  {
    "street": "Avenida Paulista, 1230 - Bela Vista, São Paulo - SP, 01310-100, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.561656,
    "emergency_lon": -46.657883,
    "local_type": "shopping_mall"
  },
  {
    "street": "Avenida Paulista, 1578 - Bela Vista, São Paulo - SP, 01310-100, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.561720,
    "emergency_lon": -46.656150,
    "local_type": "art_gallery"
  },
  {
    "street": "Rua Oscar Freire, 702 - Cerqueira César, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.561825,
    "emergency_lon": -46.673882,
    "local_type": "museum"
  },
  {
    "street": "Rua Augusta, 1000 - Consolação, São Paulo - SP, 01304-001, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.557373,
    "emergency_lon": -46.659297,
    "local_type": "book_store"
  },
  {
    "street": "Rua da Consolação, 3068 - Jardins, São Paulo - SP, 01416-000, Brasil",
    "neighborhood": "Jardins",
    "city": "São Paulo",
    "emergency_lat": -23.563417,
    "emergency_lon": -46.664890,
    "local_type": "movie_theater"
  },
  {
    "street": "Avenida Paulista, 2073 - Consolação, São Paulo - SP, 01311-300, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.563867,
    "emergency_lon": -46.656864,
    "local_type": "cafe"
  },
  {
    "street": "Rua Oscar Freire, 1113 - Jardim Paulista, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Jardim Paulista",
    "city": "São Paulo",
    "emergency_lat": -23.561575,
    "emergency_lon": -46.670206,
    "local_type": "art_gallery"
  },
  {
    "street": "Rua Augusta, 1823 - Consolação, São Paulo - SP, 01304-000, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.555868,
    "emergency_lon": -46.654755,
    "local_type": "book_store"
  },
  {
    "street": "Rua Oscar Freire, 677 - Cerqueira César, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.561765,
    "emergency_lon": -46.674218,
    "local_type": "museum"
  },
  {
    "street": "Avenida Paulista, 1230 - Bela Vista, São Paulo - SP, 01310-100, Brasil",
    "neighborhood": "Bela Vista",
    "city": "São Paulo",
    "emergency_lat": -23.561656,
    "emergency_lon": -46.657883,
    "local_type": "shopping_mall"
  },
  {
    "street": "Rua Augusta, 575 - Consolação, São Paulo - SP, 01305-000, Brasil",
    "neighborhood": "Consolação",
    "city": "São Paulo",
    "emergency_lat": -23.554968,
    "emergency_lon": -46.655796,
    "local_type": "cafe"
  },
  {
    "street": "Avenida Brigadeiro Faria Lima, 2232 - Jardim Paulistano, São Paulo - SP, 01452-000, Brasil",
    "neighborhood": "Jardim Paulistano",
    "city": "São Paulo",
    "emergency_lat": -23.580301,
    "emergency_lon": -46.687454,
    "local_type": "art_gallery"
  },
  {
    "street": "Avenida Higienópolis, 18 - Higienópolis, São Paulo - SP, 01238-000, Brasil",
    "neighborhood": "Higienópolis",
    "city": "São Paulo",
    "emergency_lat": -23.540769,
    "emergency_lon": -46.657975,
    "local_type": "museum"
  },
  {
    "street": "Rua Aspicuelta, 240 - Vila Madalena, São Paulo - SP, 05433-010, Brasil",
    "neighborhood": "Vila Madalena",
    "city": "São Paulo",
    "emergency_lat": -23.554970,
    "emergency_lon": -46.688731,
    "local_type": "book_store"
  },
  {
    "street": "Avenida Sumaré, 145 - Perdizes, São Paulo - SP, 01255-001, Brasil",
    "neighborhood": "Perdizes",
    "city": "São Paulo",
    "emergency_lat": -23.535985,
    "emergency_lon": -46.676882,
    "local_type": "movie_theater"
  },
  {
    "street": "Rua Fradique Coutinho, 1340 - Pinheiros, São Paulo - SP, 05416-001, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.568584,
    "emergency_lon": -46.686381,
    "local_type": "cafe"
  },
  {
    "street": "Rua Doutor Virgílio de Carvalho Pinto, 127 - Pinheiros, São Paulo - SP, 05415-030, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.568041,
    "emergency_lon": -46.685309,
    "local_type": "art_gallery"
  },
  {
    "street": "Rua Oscar Freire, 687 - Cerqueira César, São Paulo - SP, 01426-001, Brasil",
    "neighborhood": "Cerqueira César",
    "city": "São Paulo",
    "emergency_lat": -23.561755,
    "emergency_lon": -46.674026,
    "local_type": "book_store"
  },
  {
    "street": "Rua dos Pinheiros, 189 - Pinheiros, São Paulo - SP, 05422-010, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.566299,
    "emergency_lon": -46.683129,
    "local_type": "museum"
  },
  {
    "street": "Rua Doutor Virgílio de Carvalho Pinto, 167 - Pinheiros, São Paulo - SP, 05415-030, Brasil",
    "neighborhood": "Pinheiros",
    "city": "São Paulo",
    "emergency_lat": -23.567932,
    "emergency_lon": -46.685206,
    "local_type": "shopping_mall"
  },
  {
    "street": "Rua Aspicuelta, 150 - Vila Madalena, São Paulo - SP, 05433-010, Brasil",
    "neighborhood": "Vila Madalena",
    "city": "São Paulo",
    "emergency_lat": -23.554801,
    "emergency_lon": -46.688729,
    "local_type": "cafe"
  }
]

p "iniciando o Seed!"
p "criando 1 admin ID 1"
User.create!(email: "admin1@email.com", admin: "true", central: "false", password: '123123')
p "criando 2 centrais ID 2 ao 3"
User.create!(email: "central1@email.com", admin: "false", central: "true", password: '123123')
User.create!(email: "central2@email.com", admin: "false", central: "true", password: '123123')

# colocar a quantidade de ambulancias
vehicles = 8
p "criando #{vehicles} ambulancias de ID 4 ao #{vehicles + 3}"

def gerar_email(numero)
  "ambulancia#{numero}@email.com"
end

# Método para gerar um número de placa aleatório
def gerar_placa
  letras = ('A'..'Z').to_a
  numeros = ('0'..'9').to_a

  placa = ''
  3.times { placa += letras.sample }
  4.times { placa += numeros.sample }

  placa
end

# Criar ambulancias
def criar_users(quantidade)
  quantidade.times do |i|
    email = gerar_email(i + 1)
    placa = gerar_placa
    User.create!(
      email: email,
      admin: false,
      central: false,
      kind: 1,
      plate: placa,
      password: '123123'
    )
  end
end

criar_users(vehicles)

#  a quantidade de workers vehicles x 2
workers_qtd = vehicles * 2

p "criando #{workers_qtd} workers"
nomes = ['Caio', 'Lucas', 'Fernando', 'Carolina', 'Joao', 'Pedro', 'Mario', 'Jose', 'Ana', 'Maria', 'Carlos', 'Paula', 'Fernando', 'Camila', 'Rafael', 'Juliana']
sobrenomes = ['Silva', 'Santos', 'Oliveira', 'Pereira', 'Almeida', 'Rodrigues', 'Nascimento', 'Ferreira', 'Gomes', 'Carvalho', 'Martins', 'Araujo', 'Lima', 'Costa', 'Sousa', 'Barbosa']

workers_qtd.times do |i|
  nome = "#{nomes.sample} #{sobrenomes.sample}"
  occupation = case i % 4
               when 0
                 'Motorista'
               when 1..2
                 'Enfermeiro'
               else
                 'Médico'
               end
  Worker.create!(name: nome, occupation: occupation)
end


# colocar a quantidade de schedules desativados
desactivated_schedules_qtd = 200
p "criando #{desactivated_schedules_qtd} schedules desativados"



# latitude e longitude para a Grande São Paulo
MIN_LAT = -23.830833 # Latitude mínima para a Grande São Paulo
MAX_LAT = -23.356388 # Latitude máxima para a Grande São Paulo
MIN_LON = -46.825556 # Longitude mínima para a Grande São Paulo
MAX_LON = -46.365 # Longitude máxima para a Grande São Paulo

# Método para gerar uma localização dentro da Grande São Paulo
def gerar_localizacao
  lat = rand(MIN_LAT..MAX_LAT)
  lon = rand(MIN_LON..MAX_LON)
  [lat, lon]
end

# Criar schedules desativadas
desactivated_schedules_qtd.times do |i|
  worker1_id = ((i % workers_qtd) + 1)
  worker2_id = (((i + 1) % workers_qtd) + 1)
  user_id = (((i % vehicles) + 4))
  current_lat, current_lon = gerar_localizacao
  Schedule.create!(
    worker1_id: worker1_id,
    worker2_id: worker2_id,
    user_id: user_id,
    active: false,
    current_lat: current_lat,
    current_lon: current_lon
  )
end


# Método para retornar um valor aleatório entre as datas inicial e final
def generate_random_datetime(start_date, end_date)
  # Converte as datas para objetos DateTime
  start_datetime = DateTime.parse(start_date)
  end_datetime = DateTime.parse(end_date)

  # Calcula a diferença em segundos entre as datas inicial e final
  diff_seconds = (end_datetime - start_datetime) * 86400

  # Calcula um valor aleatório dentro do intervalo
  random_seconds = rand(0..diff_seconds)

  # Adiciona o valor aleatório em segundos à data inicial
  random_datetime = start_datetime + Rational(random_seconds, 86400)

  # Retorna o valor formatado
  random_datetime.to_formatted_s(:db)
end

# Método para retornar uma data e horas x horas antes de now
def random_datetime_last_x_hours(x)
  # Calcula a data e hora atual
  current_time = Time.now

  # Calcula a data e hora mínima permitida (x horas atrás)
  min_time = current_time - x * 3600  # Convertendo horas em segundos

  # Gera um valor aleatório entre min_time e current_time
  random_time = Time.at(rand(min_time.to_i..current_time.to_i))

  # Retorna o valor formatado como DB string
  random_time.strftime("%Y-%m-%d %H:%M:%S")
end

# # EMERGENCIAS ANTIGAS
# # escolher a quantidade de emergencias de preferencia maior que a quantidade de schedules
# old_emergencies_qtd = 300
# p "criando #{old_emergencies_qtd} emergencias ja socorridas"
# # escolher quando qual a data que comeca e finaliza as emergencias concluidas
# start_date = "2023-03-15"
# end_date = "2024-03-20"
# # escolher o maximo de horas q dura uma emergencia
# max_time_emergency = 6

# old_emergencies_qtd.times do
#   # Seleção aleatória de uma emergência e uma localização
#   emergencia = emergencias.sample
#   localizacao = localizacoes.sample

#   # Seleção aleatória de n_people, gravity, category e description
#   n_people = emergencia[:n_people]
#   gravity = emergencia[:gravity]
#   category = emergencia[:category]
#   description = emergencia[:description]

#   # Valores da localização da emergencia
#   street = localizacao[:street]
#   neighborhood = localizacao[:neighborhood]
#   city = localizacao[:city]
#   emergency_lat = localizacao[:emergency_lat]
#   emergency_lon = localizacao[:emergency_lon]
#   local_type = localizacao[:local_type]

#   # Seleção aleatória de start time dentro do periodo definido
#   random_start_date = generate_random_datetime(start_date, end_date)
#   random_end_date = DateTime.parse(random_start_date) + rand(1..max_time_emergency).hours

#   # Valores aleatorios de localizacao da ambulancia para inicio da chamada
#   current_lat_start, current_lon_start = gerar_localizacao

#   # Valores aleatorios de localizacao da ambulancia para final da chamada
#   current_lat_end, current_lon_end = gerar_localizacao

#   Emergency.create!(
#     n_people: n_people,
#     gravity: gravity,
#     category: category,
#     description: description,
#     street: street,
#     neighborhood: neighborhood,
#     city: city,
#     emergency_lat: emergency_lat,
#     emergency_lon: emergency_lon,
#     local_type: local_type,
#     time_start: random_start_date,
#     time_end: random_end_date,
#     start_lon: current_lon_start,
#     start_lat: current_lat_start,
#     end_lon: current_lon_end,
#     end_lat: current_lat_end,
#     user_id: rand(1..2), # aleatorio user ID para centrais
#     schedule_id: rand(1..desactivated_schedules_qtd) # aleatorio user ID para schedules desativadas
#   )
# end


# # EMERGENCIAS NOVAS COM EMERGENCIA EM ANDAMENTO

# # escolher a quantidade de emergencias de preferencia maior que a quantidade de schedules
# new_emergencies_qtd = vehicles
# p "criando #{new_emergencies_qtd} emergencias em andamento com respectiva ambulancia a caminho"
# # definir quanto horas antes as emergencias ativas foram criadas
# horas_antes = 4

# # criando um array de IDs de ambulancias
# users_array =  (4..(vehicles + 3)).to_a

# new_emergencies_qtd.times do
#   # Seleção aleatória de uma emergência e uma localização
#   emergencia = emergencias.sample
#   localizacao = localizacoes.sample


#   # Criando a schedule da ambulancia que receberá a emergencia
#   worker1_id = rand(1..workers_qtd)
#   worker2_id = rand(1..workers_qtd)
#   user_id = users_array.delete_at(0)

#   # criando localizacao para a ambulancia e para o inicio da emergencia
#   current_lat, current_lon = gerar_localizacao

#   schedule = Schedule.create!(
#     worker1_id: worker1_id,
#     worker2_id: worker2_id,
#     user_id: user_id,
#     active: true,
#     current_lat: current_lat,
#     current_lon: current_lon
#   )

#   # Seleção aleatória de n_people, gravity, category e description
#   n_people = emergencia[:n_people]
#   gravity = emergencia[:gravity]
#   category = emergencia[:category]
#   description = emergencia[:description]

#   # Valores da localização da emergencia
#   street = localizacao[:street]
#   neighborhood = localizacao[:neighborhood]
#   city = localizacao[:city]
#   emergency_lat = localizacao[:emergency_lat]
#   emergency_lon = localizacao[:emergency_lon]
#   local_type = localizacao[:local_type]

#   # escolher quando qual a data e hora que comeca e finaliza as emergencias ativas
#   start_date = random_datetime_last_x_hours(horas_antes)

#   Emergency.create!(
#     n_people: n_people,
#     gravity: gravity,
#     category: category,
#     description: description,
#     street: street,
#     neighborhood: neighborhood,
#     city: city,
#     emergency_lat: emergency_lat,
#     emergency_lon: emergency_lon,
#     local_type: local_type,
#     time_start: start_date,
#     start_lon: schedule.current_lon,
#     start_lat: schedule.current_lat,
#     user_id: rand(1..2), # aleatorio user ID para centrais
#     schedule_id: schedule.id # aleatorio user ID para schedules desativadas
#   )
# end


# >>>>>>>>>>>>>>> BLAZER DASHBOARDS E QUERIES <<<<<<<<<<<<<<<<<<<<<<

p "Criacao dos dashboards e queries do Blazer"
  # Criar um novo dashboard
  p "Criacao de 1 dashboards"
  dashboard = Blazer::Dashboard.create!(
    name: "3-Ocorrências Por Data"
  )
  query = Blazer::Query.create!(
    name: "Ocorrências por bairro (data)",
    description: "Visao por data",
    data_source: "main",
    statement: "SELECT
    neighborhood,
    COUNT(*) AS total_occurrences
  FROM
    emergencies
  WHERE
    time_start >= {start_time}
    AND time_start <= {end_time}
  GROUP BY
    neighborhood
  ORDER BY
    total_occurrences DESC;"
  )
  p "Adicionando query ao dashboard"
  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 0)


  query = Blazer::Query.create!(
    name: "Categoria das ocorrências (data)",
    description: "Visao por data",
    data_source: "main",
    statement: "SELECT
    CASE category
        WHEN 1 THEN 'Acidentes de trânsito'
        WHEN 2 THEN 'Mal súbito'
        WHEN 3 THEN 'Ferimentos por queda'
        WHEN 4 THEN 'Parada cardiorrespiratória'
        WHEN 5 THEN 'Intoxicação ou envenenamento'
        WHEN 6 THEN 'Problemas respiratórios'
        WHEN 7 THEN 'Crises hipertensivas'
        WHEN 8 THEN 'Complicações durante a gravidez ou parto'
        WHEN 9 THEN 'Ferimentos por arma branca ou de fogo'
        WHEN 10 THEN 'Reações alérgicas graves'
        WHEN 11 THEN 'Outros'
        ELSE 'Desconhecido'
    END AS category_name,
    COUNT(*) AS total_occurrences
  FROM
    emergencies
  WHERE
    time_start >= {start_time}
    AND time_start <= {end_time}
  GROUP BY
    category
  ORDER BY
    total_occurrences DESC;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 1)

  query = Blazer::Query.create!(
    name: "Detalhado (data)",
    description: "Visao por data",
    data_source: "main",
    statement: "SELECT
    description AS Descrição,
    time_start AS Data,
    gravity AS Gravidade,
    n_people AS Número_de_vítimas_socorridas
  FROM
    emergencies
  WHERE
    time_start >= {start_time}
    AND time_start <= {end_time}
  ORDER BY
    time_start;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 2)



  # Criar um novo dashboard
  dashboard = Blazer::Dashboard.create!(
    name: "1-Visao Geral por Cidade"
  )

  query = Blazer::Query.create!(
    name: "Total de ocorrências por bairro (cidade)",
    description: "Visao Cidade",
    data_source: "main",
    statement: "SELECT
    neighborhood,
    COUNT(*) AS total_occurrences
  FROM
    emergencies
  WHERE
    city = {Cidade}
  GROUP BY
    neighborhood
  ORDER BY
    total_occurrences DESC;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 0)

  query = Blazer::Query.create!(
    name: "Categoria das ocorrências (cidade)",
    description: "Visao Cidade",
    data_source: "main",
    statement: "SELECT
    CASE category
        WHEN 1 THEN 'Acidentes de trânsito'
        WHEN 2 THEN 'Mal súbito'
        WHEN 3 THEN 'Ferimentos por queda'
        WHEN 4 THEN 'Parada cardiorrespiratória'
        WHEN 5 THEN 'Intoxicação ou envenenamento'
        WHEN 6 THEN 'Problemas respiratórios'
        WHEN 7 THEN 'Crises hipertensivas'
        WHEN 8 THEN 'Complicações durante a gravidez ou parto'
        WHEN 9 THEN 'Ferimentos por arma branca ou de fogo'
        WHEN 10 THEN 'Reações alérgicas graves'
        WHEN 11 THEN 'Outros'
        ELSE 'Desconhecido'
    END AS category_name,
    COUNT(*) AS occurrences_count
  FROM
    emergencies
  WHERE
    city = {Cidade}
  GROUP BY
    category_name  -- Usando category_name em vez de category para manter o alias
  ORDER BY
    occurrences_count DESC;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 1)

  query = Blazer::Query.create!(
    name: "Mapa das ocorrência (cidade)",
    description: "Visao Cidade",
    data_source: "main",
    statement: "SELECT
    id,
    description,
    emergency_lon AS longitude,
    emergency_lat AS latitude,
    time_start,
    gravity,
    category
  FROM
    emergencies
  WHERE
    city = {Cidade};"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 2)



  # Criar um novo dashboard
  dashboard = Blazer::Dashboard.create!(
    name: "2-Visao Geral por Bairro"
  )

  query = Blazer::Query.create!(
    name: "Categoria das ocorrências (bairro)",
    description: "Visao bairro",
    data_source: "main",
    statement: "SELECT
    CASE category
        WHEN 1 THEN 'Acidentes de trânsito'
        WHEN 2 THEN 'Mal súbito'
        WHEN 3 THEN 'Ferimentos por queda'
        WHEN 4 THEN 'Parada cardiorrespiratória'
        WHEN 5 THEN 'Intoxicação ou envenenamento'
        WHEN 6 THEN 'Problemas respiratórios'
        WHEN 7 THEN 'Crises hipertensivas'
        WHEN 8 THEN 'Complicações durante a gravidez ou parto'
        WHEN 9 THEN 'Ferimentos por arma branca ou de fogo'
        WHEN 10 THEN 'Reações alérgicas graves'
        WHEN 11 THEN 'Outros'
        ELSE 'Desconhecido'
    END AS category_name,
    SUM(CASE WHEN city = {Cidade} AND neighborhood = {Bairro} THEN 1 ELSE 0 END) AS total_occurrences
  FROM
    emergencies
  GROUP BY
    category_name
  ORDER BY
    total_occurrences DESC;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 0)

  query = Blazer::Query.create!(
    name: "Mapa das ocorrências (bairro)",
    description: "Visao bairro",
    data_source: "main",
    statement: "SELECT
    id,
    description,
    emergency_lon AS longitude,
    emergency_lat AS latitude,
    time_start,
    gravity,
    category
  FROM
    emergencies
  WHERE
    city = {Cidade}
    AND neighborhood = {Bairro};"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 1)

  query = Blazer::Query.create!(
    name: "Detalhado (bairro)",
    description: "Visao bairro",
    data_source: "main",
    statement: "SELECT
    description AS Descrição,
    time_start AS Data,
    gravity AS Gravidade,
    n_people AS Número_de_vitimas_socorridas
  FROM
    emergencies
  WHERE
    city = {Cidade}
    AND neighborhood = {Bairro}
  ORDER BY
    time_start;"
  )

  # Adicionar a query ao dashboard
  dashboard.dashboard_queries.create!(query: query, position: 2)

# >>>>>>>>>>>>>>>FIM BLAZER DASHBOARDS E QUERIES <<<<<<<<<<<<<<<<<<<<<<

p 'Criacao do chatroom e 2 mensagens'
Chatroom.create!(name: "General")
# Chat.create!(name: "Le Wagon`s Hospital")

p 'Criacao de 1 estoque'
stock1 = Stock.create(tesoura: 3, luvas: 8, pinça: 2, esparadrapo: 6, alcool: 2, gaze_esterilizada: 4, atadura: 10, bandagens: 10, medicamentos_basicos: 10, user_id: 4)
stock1.save!

p 'criacao de 6 hospitais'
hospital01 = Hospital.create!(name: "Le Wagon Hospital", latitude: -23.55195, longitude: -46.68898)
hospital02 = Hospital.create!(name: "Hospital São Paulo", latitude: -23.56334, longitude: -46.65454)
hospital03 = Hospital.create!(name: "Hospital das Clínicas", latitude: -23.56063, longitude: -46.72899)
hospital04 = Hospital.create!(name: "Hospital Albert Einstein", latitude: -23.58829, longitude: -46.66477)
hospital05 = Hospital.create!(name: "Hospital Sírio-Libanês", latitude: -23.55984, longitude: -46.67787)
hospital06 = Hospital.create!(name: "Hospital Israelita Albert Sabin", latitude: -23.55414, longitude: -46.65555)

p "finalizando o seed"
