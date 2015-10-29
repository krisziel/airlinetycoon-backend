
#
# AircraftConfiguration.create(name:"High Density",aircraft_id:1,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
# AircraftConfiguration.create(name:"High Density",aircraft_id:2,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
# AircraftConfiguration.create(name:"High Density",aircraft_id:3,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:400,f_seat:0,j_seat:0,p_seat:2,y_seat:1)
# AircraftConfiguration.create(name:"High Density",aircraft_id:4,airline_id:1,f_count:0,j_count:0,p_count:80,y_count:300,f_seat:0,j_seat:0,p_seat:2,y_seat:1)

# reset id index: ActiveRecord::Base.connection.reset_pk_sequence!('')

# Game.create(region:'all',name:'Worldwide',year:2015)
# User.create(name:'United Airlines',username:'ual',password:'ual',email:'krisziel@mac.com')
# User.create(name:'American Airlines',username:'aal',password:'aal',email:'kz@kziel.com')
# User.create(name:'Delta Air Lines',username:'dal',password:'dal',email:'kris@kziel.com')
# User.create(name:'JetBlue Airways',username:'jbu',password:'jbu',email:'me@kziel.com')
# User.create(name:'Virgin America',username:'vrd',password:'vaa',email:'k.ziel@icloud.com')
# Airline.create(name:'United Airlines',icao:'UAL',money:5000000000,game_id:1,user_id:1)
# Airline.create(name:'American Airlines',icao:'AAL',money:5000000000,game_id:1,user_id:2)
# Airline.create(name:'Delta Air Lines',icao:'DAL',money:5000000000,game_id:1,user_id:3)
# Airline.create(name:'JetBlue Airways',icao:'JBU',money:5000000000,game_id:1,user_id:4)
# Airline.create(name:'Virgin America',icao:'VRD',money:5000000000,game_id:1,user_id:5)

########### UAL
# AircraftConfiguration.create(name:"International",aircraft_id:13,airline_id:1,f_count:10,j_count:58,p_count:63,y_count:232,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 77W
# AircraftConfiguration.create(name:"International",aircraft_id:4,airline_id:1,f_count:10,j_count:54,p_count:90,y_count:230,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 744
# AircraftConfiguration.create(name:"International",aircraft_id:6,airline_id:1,f_count:0,j_count:16,p_count:48,y_count:116,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 752 intl
# AircraftConfiguration.create(name:"Domestic",aircraft_id:6,airline_id:1,f_count:0,j_count:16,p_count:60,y_count:96,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 752 dom
# AircraftConfiguration.create(name:"p.s.",aircraft_id:6,airline_id:1,f_count:8,j_count:24,p_count:55,y_count:30,f_seat:9,j_seat:6,p_seat:2,y_seat:1)
# AircraftConfiguration.create(name:"International",aircraft_id:9,airline_id:1,f_count:6,j_count:36,p_count:62,y_count:129,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 763
# AircraftConfiguration.create(name:"International",aircraft_id:15,airline_id:1,f_count:6,j_count:40,p_count:60,y_count:188,f_seat:0,j_seat:0,p_seat:2,y_seat:1) # 789

######### AAL
# AircraftConfiguration.create(name:"International",aircraft_id:13,airline_id:2,f_count:10,j_count:58,p_count:63,y_count:232,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 77W
# AircraftConfiguration.create(name:"Transcon",aircraft_id:20,airline_id:2,f_count:8,j_count:26,p_count:24,y_count:57,f_seat:9,j_seat:6,p_seat:2,y_seat:1) # 321T

######### DAL
# AircraftConfiguration.create(name:"International",aircraft_id:9,airline_id:3,f_count:6,j_count:36,p_count:62,y_count:129,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 763
# AircraftConfiguration.create(name:"International",aircraft_id:6,airline_id:3,f_count:0,j_count:16,p_count:60,y_count:96,f_seat:9,j_seat:6,p_seat:3,y_seat:1) # 752 dom

######### JBU
# AircraftConfiguration.create(name:"Mint",aircraft_id:20,airline_id:4,f_count:0,j_count:24,p_count:24,y_count:116,f_seat:9,j_seat:6,p_seat:2,y_seat:1) # 321T

######### VRD
# AircraftConfiguration.create(name:"Domestic",aircraft_id:19,airline_id:5,f_count:0,j_count:16,p_count:24,y_count:97,f_seat:9,j_seat:6,p_seat:2,y_seat:1) # 321T

######### For testing fares with connections
# UserAircraft.create(airline_id:3,aircraft_id:29,age:1,aircraft_configuration_id:11,inuse:false)
# Flight.create(route_id:1428,user_aircraft_id:64,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1181,user_aircraft_id:65,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1219,user_aircraft_id:66,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1645,user_aircraft_id:67,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1657,user_aircraft_id:68,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1097,user_aircraft_id:69,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1109,user_aircraft_id:70,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:872,user_aircraft_id:71,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:856,user_aircraft_id:72,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:2584,user_aircraft_id:73,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:1657,user_aircraft_id:74,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
# Flight.create(route_id:4032,user_aircraft_id:75,duration:570,passengers:{y:700,p:200,j:170,f:30},load:{:y=>96,:j=>86,:p=>88,:f=>65},profit:{:y=>20000,:p=>8600,:j=>8800,:f=>7300},frequencies:20,fare:'{"y":580,"p":1900,"j":3380,"f":4690}',revenue:98000,cost:120000,airline_id:3)
