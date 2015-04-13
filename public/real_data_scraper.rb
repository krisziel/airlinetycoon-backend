class RealData
	
	def initialize
		@airports = {"DAN"=>1, "AIS"=>2, "BEA"=>3, "UTI"=>4, "FUL"=>5, "SIN"=>6, "HKG"=>7, "LAX"=>8, "JFK"=>9, "EWR"=>10, "SFO"=>11, "IAD"=>12, "IAH"=>13, "ORD"=>14, "DEN"=>15, "TPE"=>16, "PER"=>17, "SYD"=>18, "MEL"=>19, "LHR"=>20, "EDI"=>21, "GLA"=>22, "MAN"=>23, "CDG"=>24, "TBS"=>25, "DME"=>26, "FCO"=>27, "MXP"=>28, "TLV"=>29, "ROR"=>30, "YCG"=>31, "RAN"=>32, "TIS"=>33, "STU"=>34, "NNI"=>35, "NGO"=>36, "GRU"=>37, "GIG"=>38, "AKL"=>39, "EZE"=>40, "VIE"=>41, "BAH"=>42, "BRU"=>43, "YOW"=>44, "YYT"=>45, "YYC"=>46, "YVR"=>47, "SCL"=>48, "PEK"=>49, "PVG"=>50, "CAI"=>51, "KIX"=>52, "NRT"=>53, "FUK"=>54, "TXL"=>55, "FRA"=>56, "MUC"=>57, "GUM"=>58, "DEL"=>59, "SNN"=>60, "MFM"=>61, "KUL"=>62, "PVR"=>63, "CUN"=>64, "MEX"=>65, "TIJ"=>66, "AMS"=>67, "PTY"=>68, "DOH"=>69, "ICN"=>70, "BCN"=>71, "ZRH"=>72, "GVA"=>73, "IST"=>74, "MSP"=>75, "LAS"=>76, "MEM"=>77, "LIH"=>78, "ABQ"=>79, "FLL"=>80, "MIA"=>81, "MSY"=>82, "PHX"=>83, "SAN"=>84, "HNL"=>85, "OGG"=>86, "KOA"=>87, "OMA"=>88, "OKC"=>89, "DTW"=>90, "DFW"=>91, "CLE"=>92, "CLT"=>93, "FAR"=>94, "ANC"=>95, "RNO"=>96, "BOI"=>97, "BOS"=>98, "COS"=>99, "BZN"=>100, "MCO"=>101, "SJC"=>102, "SMF"=>103, "SEA"=>104, "PDX"=>105, "RDU"=>106, "YUL"=>107, "SJD"=>108, "TPA"=>109, "PIT"=>110, "TUS"=>111, "PHL"=>112, "CMH"=>113, "AUS"=>114, "AMA"=>115, "ATL"=>116, "SAT"=>117, "DWC"=>118, "DXB"=>119, "MLE"=>120, "AUH"=>121, "KWI"=>122, "JAX"=>123}
		@base = 'https://api.flightstats.com/flex/flightstatus/rest/v2/json'
		@auth = "?appId=8e45847d&appKey=#{ENV['FS_KEY']}&utc=false&numHours=6"
		@aircraft = ["76Y", "33F", "32B", "A343", "AT7", "CL60", "SF34", "77F", "DH8A", "SH6", "75W", "B733", "B712", "767", "310", "787", "737", "B762", "CR9", "747", "B763", "EMJ", "M88", "B773", "744", "345", "738", "DH8C", "773", "A346", "772", "M80", "33X", "318", "CRJ", "B753", "757", "A332", "B732", "E55P", "E135", "CNA", "73G", "789", "A310", "B77L", "E145", "ERJ", "E70", "E90", "B738", "74H", "73J", "CRJ9", "DC10", "B190", "330", "H25B", "74Y", "A321", "346", "32A", "72F", "ABY", "E120", "B77W", "A306", "76W", "753", "DH8", "AT72", "AB6", "F70", "76F", "752", "A333", "340", "717", "733", "AR1", "74N", "736", "C560", "DH8D", "FA20", "73W", "DH8B", "73Y", "AT5", "73C", "BE40", "763", "SW4", "DH4", "E170", "ABF", "B748", "CR7", "E95", "JS32", "CL30", "M88", "BE99", "A320", "F2TH", "CRJ7", "C680", "788", "DH1", "B744", "B788", "ABX", "B737", "GLF5", "M1F", "M83", "M11", "B739", "734", "S20", "735", "M90", "380", "M90", "CRJ2", "E190", "332", "333", "DH2", "74E", "762", "GLEX", "CRA", "GALX", "388", "343", "SF3", "320", "B734", "14X", "74F", "AT45", "B742", "E45X", "B772", "319", "C750", "B764", "73H", "DH3", "777", "B752", "32S", "77L", "739", "77W", "PA31", "31F", "ERD", "ER4", "321", "A388", "73F", "74M", "A319", "764", "C56X", "E75", "C208", "100", "SU9", "77X", "75F"]
		@clean = ["76Y","33F","32B","343","AT7","XXX","SF3","77F","DH1","SH6","75W","733","712","767","310","787","737","762","CR9","747","763","EMJ","M88","773","744","345","738","DH3","773","346","772","M80","33X","318","CRJ","753","757","332","732","XXX","ER3","CNA","73G","789","310","77L","ER4","ERJ","E70","E90","738","74H","73J","CR9","D1F","BES","330","XXX","74Y","321","346","32A","72F","ABY","ER2","77W","306","76W","753","DH8","AT7","AB6","F70","76F","752","333","340","717","733","AR1","74N","736","XXX","DH4","XXX","73W","DH2","73Y","AT5","73C","XXX","763","SW4","DH4","E70","ABF","748","CR7","E95","XXX","XXX","M88","XXX","320","XXX","CR7","XXX","788","DH1","744","788","ABX","737","XXX","M1F","M83","M11","739","734","S20","735","M90","380","M90","CR2","E90","332","333","DH2","74E","762","XXX","CRA","XXX","388","343","SF3","320","734","14X","74F","AT4","742","ER4","772","319","XXX","764","73H","DH3","777","752","32S","77L","739","77W","XXX","31F","ERD","ER4","321","388","73F","74M","319","764","XXX","E75","XXX","100","SU9","77X","75F"]
	end
	
	def airport_loop
		@airports.each_key do |airport|
			# get_flights airport
		end
	end
	
	def get_flights *airport
		airport = params[:iata] || airport[0]
		flights = []
		times = [0,6,12,18]
		times.each do |time|
			time_block = JSON.parse(RestClient.get("#{@base}/airport/status/#{airport}/dep/2015/04/09/#{time}#{@auth}"))
			time_block["flightStatuses"].each{|flight| flights.push(parse_flight(flight)) }
		end
		flights.each do |flight|
			ActualFlight.new(flight).save
		end
	end
	
	def parse_flight flight
		p flight
		origin = @airports[flight["departureAirportFsCode"]]
		destination = @airports[flight["arrivalAirportFsCode"]]
		new_flight = {}
		if origin && destination
			if flight["flightEquipment"]
				equipment = flight["flightEquipment"]["actualEquipmentIataCode"] || flight["flightEquipment"]["scheduledEquipmentIataCode"]
			else
				equipment = nil
			end
			if flight["flightDurations"]
				duration = flight["flightDurations"]["blockMinutes"]
			else
				duration = 0
			end
			new_flight = {
				origin_id:origin,
				destination_id:destination,
				duration:duration,
				equipment:equipment,
				carrier:flight["carrierFsCode"],
				flight:flight["flightNumber"]
			}
		end
		new_flight
	end

	def get_aircraft
		doc = Nokogiri::HTML(RestClient.get("http://www.flugzeuginfo.net/table_accodes_iata_en.php"))
		doc.css('.codes tr')[1..-1].each do |row|
			ac = row.css('td')
			code = ac[0].text
			manufacturer = ac[1].text
			name = ac[2].text
			codes = @clean.each_index.select{|i| @clean[i] == code}
			if codes.length > 0
				p @aircraft[@clean.index(code)]
				codes.each do |fs_code|
					ActualAircraft.create(iata:code,fs_iata:@aircraft[fs_code],name:name,manufacturer:manufacturer)
				end
			end
		end
	end

	def add_capacity
    CSV.foreach("public/ac.csv") do |row|
    	row[5] ? capacity = row[5] : capacity = 0
    	ActualAircraft.where(iata:row[1]).update_all(capacity:capacity)
    end
	end

	def update_flights
		i = 0
		ActualFlight.all.each do |flight|
			p i
			i += 1
			if flight.equipment
				ac = ActualAircraft.find_by("fs_iata=? OR iata=?",flight.equipment,flight.equipment)
				if ac && ac.capacity
					flight.update(capacity:ac.capacity)
				end
			end
		end
	end

	def clean_flights
		routes = {}
		ActualFlight.uniq.pluck(:carrier, :flight).each do |flight|
			flt = ActualFlight.find_by("carrier=? AND flight=?",flight[0],flight[1])
			origin = flt.origin_id
			destination = flt.destination_id
			route = routes[[origin,destination]]
			if route
				route.push(flt)
			else
				routes[[origin,destination]] = [flt]
			end
		end
		routes
	end

	def get_configuration
		doc = Nokogiri::HTML(RestClient.get('http://www.seatguru.com/charts/shorthaul_economy.php'))
		doc.css('#chart tr')[9..-1].each do |aircraft|
			url = aircraft.css('td a')[1].attr('href')
			parse_configuration url
		end
	end

	def parse_configuration url
		url = "http://www.seatguru.com/#{url}"
		doc = Nokogiri::HTML(RestClient.get(url))
		config_name = doc.css('.h2-fix').text
		carrier = doc.css('.h1-fix').text.match(/([a-z ]+) Seat/i)[1]
		if config_name.match(/\(([a-z0-9]{3})\)|\//i)
			iata = config_name.match(/\(([a-z0-9]{3})\)|\//i)[1]
			seats = doc.css('.seat-list tbody tr')
			seat_arr = {
				f:0,
				j:0,
				p:0,
				y:0,
				total:0
			}
			seats.each_with_index do |seat,i|
				seat = seat.css('td')
				name = seat[1].text
				count = seat[4].css('.value').text
				count = count.match(/([0-9]+)\ /)[1].to_i
				seat_arr[:total] += count
				if seats.length == 4
					seat_arr[:f] = count if i == 0
					seat_arr[:j] = count if i == 1
					seat_arr[:p] = count if i == 2
					seat_arr[:y] = count if i == 3
				else
					seat_arr[:f] = count if name.match(/First|Suite/i)
					seat_arr[:j] = count if name.match(/Business/i)
					seat_arr[:p] = count if name.match(/Plus|Comfort|Premium/i)
					seat_arr[:y] = count if name.match(/Economy/i)
				end
			end
			config = {
				name:config_name,
				carrier:carrier,
				iata:iata,
				config:seat_arr
			}
			ActualConfiguration.new(config).save
		end
	end

	def correct_equip
		ActualFlight.all.each do |flight|
			iata = flight.equipment
			if flight.equipment && flight.equipment.length > 3
				aircraft = ActualAircraft.find_by(fs_iata:flight.equipment)
				if aircraft
					iata = aircraft.iata
				end
			end
			flight.update(iata:iata)
		end
	end

	def merge_config flights
		flights.each do |flight|
			config = ActualConfiguration.select(:config).find_by(carrier:flight.carrier,iata:flight.iata)
			if config
				cabins = config.config["f"].to_i + config.config["j"].to_i + config.config["p"].to_i + config.config["y"].to_i
				total = config.config["total"]
				if cabins == total
					cap = {
						:f => config.config["f"],
						:j => config.config["j"],
						:p => config.config["p"],
						:y => config.config["y"],
						:total => config.config["total"]
					}
				elsif cabins == 0
					cap = config_distro total
				else
					config.config["y"] = total - cabins
					cap = config.config
				end
				flight.update(capacity:cap.to_s)
			else
				capacity = ActualAircraft.find_by(iata:flight.iata)
				if capacity
					if capacity.capacity
						capacity = config_distro capacity.capacity
						flight.update(capacity:capacity.to_s)
					end
				end
			end
		end
	end

	def import_csv file
		require 'csv'
		csv_text = File.read(file)
		csv = CSV.parse(csv_text, :headers => true)
		csv.each do |row|
			row.each do |value|
				if value[1] && value[1].match(/\(\w+:\w+\)/i)
					value[1] = csv_to_json value[1]
				end
			end
		  ActualAircraft.create!(row.to_hash)
		end
	end

	def config_distro total_capacity
		capacity = {
			f:0.0,
			j:0.0,
			p:0.0,
			y:0.0
		}
		if total_capacity > 250
			capacity[:f] = 0.03
			capacity[:j] = 0.15
			capacity[:p] = 0.17
			capacity[:y] = 0.65
		elsif total_capacity > 50
			capacity[:f] = 0.0
			capacity[:j] = 0.12
			capacity[:p] = 0.17
			capacity[:y] = 0.65
		end
		capacity = {
			:f => (total_capacity*capacity[:f]).round,
			:j => (total_capacity*capacity[:j]).round,
			:p => (total_capacity*capacity[:p]).round,
			:y => (total_capacity*capacity[:y]).round,
			:total => total_capacity
		}
		capacity
	end

	def csv_to_json string
		string.gsub!(/^\(/,'')
		string.gsub!(/\)$/,'')
		parts = string.split(")(")
		json = {}
		parts.each do |part|
			key = part.split(':')[0]
			val = part.split(':')[1]
			json[key.to_sym] = val.to_i
		end
		json
	end

end

