class FlightstatsController < ApplicationController
	
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
		doc.css('.codes tr').each do |row|
			ac = row.css('td')
			code = ac[0].text
			manufacturer = ac[1].text
			name = ac[2].text
			p code
			if @clean.index(code)
				ActualAircraft.create(iata:code,fs_iata:@aircraft[@clean.index(code)],name:name,manufacturer:manufacturer)
			end
		end
	end

end

