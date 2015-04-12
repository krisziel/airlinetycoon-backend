class FlightstatsController < ApplicationController
	
	def initialize
		@airports = {"DAN"=>1, "AIS"=>2, "BEA"=>3, "UTI"=>4, "FUL"=>5, "SIN"=>6, "HKG"=>7, "LAX"=>8, "JFK"=>9, "EWR"=>10, "SFO"=>11, "IAD"=>12, "IAH"=>13, "ORD"=>14, "DEN"=>15, "TPE"=>16, "PER"=>17, "SYD"=>18, "MEL"=>19, "LHR"=>20, "EDI"=>21, "GLA"=>22, "MAN"=>23, "CDG"=>24, "TBS"=>25, "DME"=>26, "FCO"=>27, "MXP"=>28, "TLV"=>29, "ROR"=>30, "YCG"=>31, "RAN"=>32, "TIS"=>33, "STU"=>34, "NNI"=>35, "NGO"=>36, "GRU"=>37, "GIG"=>38, "AKL"=>39, "EZE"=>40, "VIE"=>41, "BAH"=>42, "BRU"=>43, "YOW"=>44, "YYT"=>45, "YYC"=>46, "YVR"=>47, "SCL"=>48, "PEK"=>49, "PVG"=>50, "CAI"=>51, "KIX"=>52, "NRT"=>53, "FUK"=>54, "TXL"=>55, "FRA"=>56, "MUC"=>57, "GUM"=>58, "DEL"=>59, "SNN"=>60, "MFM"=>61, "KUL"=>62, "PVR"=>63, "CUN"=>64, "MEX"=>65, "TIJ"=>66, "AMS"=>67, "PTY"=>68, "DOH"=>69, "ICN"=>70, "BCN"=>71, "ZRH"=>72, "GVA"=>73, "IST"=>74, "MSP"=>75, "LAS"=>76, "MEM"=>77, "LIH"=>78, "ABQ"=>79, "FLL"=>80, "MIA"=>81, "MSY"=>82, "PHX"=>83, "SAN"=>84, "HNL"=>85, "OGG"=>86, "KOA"=>87, "OMA"=>88, "OKC"=>89, "DTW"=>90, "DFW"=>91, "CLE"=>92, "CLT"=>93, "FAR"=>94, "ANC"=>95, "RNO"=>96, "BOI"=>97, "BOS"=>98, "COS"=>99, "BZN"=>100, "MCO"=>101, "SJC"=>102, "SMF"=>103, "SEA"=>104, "PDX"=>105, "RDU"=>106, "YUL"=>107, "SJD"=>108, "TPA"=>109, "PIT"=>110, "TUS"=>111, "PHL"=>112, "CMH"=>113, "AUS"=>114, "AMA"=>115, "ATL"=>116, "SAT"=>117, "DWC"=>118, "DXB"=>119, "MLE"=>120, "AUH"=>121, "KWI"=>122, "JAX"=>123}
		@base = 'https://api.flightstats.com/flex/flightstatus/rest/v2/json'
		@auth = '?appId=8e45847d&appKey=c57485c1d166d52b3281f836b3d07ceb&utc=false&numHours=6'
	end
	
	def airport_loop
		@airports.each_key do |airport|
			get_flights airport
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

end