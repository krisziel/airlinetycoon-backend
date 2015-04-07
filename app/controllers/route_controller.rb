class RouteController < ApplicationController
  before_action :airline

  def show
    if airline
      if params[:id]
        route = Route.find(params[:id])
        route = route.serialize_flights
      elsif params[:o] && params[:d]
        route = Route.find_by('(origin_id=? AND destination_id=?) OR (origin_id=? AND destination_id=?)',params[:o],params[:d],params[:d],params[:o])
        if route
          route = route.serialize_flights
        else
          route = {
            error: 'no route'
          }
        end
      else
        route = {
          error: 'no route'
        }
      end
    else
      route = {
        error: 'no airline'
      }
    end
    render json: route
  end

  def airport
    if airline
      airport = Airport.find_by(iata:params[:iata])
      if airport
        routes = Route.where("origin=? OR destination=?",airport,airport)
      else
        routes = {error:'airport does not exist'}
      end
    else
      routes = {error:'user not logged in'}
    end
    render json: routes
  end

  def generator
    # <Route id: 1, origin_id: 1, destination_id: 2, distance: 6624, minfare: {"f"=>500, "j"=>400, "p"=>250, "y"=>175}, maxfare: {"f"=>1500, "j"=>1350, "p"=>1150, "y"=>1050}, price: {"f"=>950, "j"=>900, "p"=>850, "y"=>800},
    # demand: {"f"=>50, "j"=>120, "p"=>400, "y"=>1000}, elasticity: {"f"=>"a", "j"=>"b", "p"=>"c", "y"=>"d"}, created_at: "2015-03-18 09:05:07", updated_at: "2015-03-18 09:05:07">
  end

  def parse_demand
    json = []
    CSV.foreach("public/us.csv") do |row|
      if row[6].class == String
        pax = row[6].gsub(/\,/,'')
      else
        pax = row[6]
      end
      if row[5].class == String
        fare = row[6].gsub(/\,/,'')
      else
        fare = row[6]
      end
      json.push({
        :origin => row[3],
        :destination => row[4],
        :pax => pax.to_f.ceil,
        :fare => fare.to_f.ceil
      })
    end
    routes = json
    new_json = []
    routes.each do |route|
      if route.class == Hash
        origin = Airport.where(:iata => route[:origin])
        dest = Airport.where(:iata => route[:destination])
        if origin.length == 0 || dest.length == 0

        else
          existingRoute = Route.where(:origin_id => dest[0].id, :destination_id => origin[0].id)
          if existingRoute.length == 0 && route[:pax] > 0 && route[:fare] > 0
            pax = route[:pax]
            fare = route[:fare]
            route_data = {
              :origin_id => origin[0].id,
              :destination_id => dest[0].id,
              :demand => {
                y:(pax*0.65),
                p:(pax*0.15),
                j:(pax*0.10),
                f:(pax*0.07)
              },
              :price => {
                y:(fare*0.65),
                p:(fare*1.1),
                j:(fare*1.5),
                f:(fare*1.9)
              }
            }
            new_route = Route.create!(route_data)
            new_json.push(new_route)
            distance new_route.id
          end
        end
      end
    end
    render json: new_json
  end

  def generate_routes
    all_data = []
    all_airports = Airport.all
    all_airports.each do |airport|
      other_airports = Airport.where("iata <> ?", airport.iata)
      other_airports.each do |destination|
        route = Route.where("origin_id IN (?) AND destination_id IN (?)",[destination.id,airport.id],[destination.id,airport.id])
        if route.length == 0
          fare_info = return_dist(airport, destination)
          fare_price = generate_fare_price fare_info, airport.population, destination.population
          new_route = {
            :origin_id => airport.id,
            :destination_id => destination.id,
            :distance => fare_info[:distance],
            :minfare => fare_info[:min],
            :maxfare => fare_info[:max],
          }
          route_data = new_route.merge!(fare_price)
          all_data.push(Route.create(route_data))
        end
      end
    end
    render json: all_data
  end

  def generate_fare_price fare_info, origin_pop, dest_pop
    pax = (((80+rand(40))*0.01)*([origin_pop,dest_pop].min)*0.0007)*7
    fare = 100+(fare_info[:distance]*0.3)
    continium = ((80+rand(40))*0.01)
    fare_x = {
      :f => 4.0,
      :j => 3.0,
      :p => 1.4,
      :y => 0.65
    }
    demand_x = {
      :f => 0.1,
      :j => 0.1,
      :p => 0.15,
      :y => 0.65
    }
    fares = {
      :f => fare_x[:f]*fare,
      :j => fare_x[:j]*fare,
      :p => fare_x[:p]*fare,
      :y => fare_x[:y]*fare
    }
    demand = {
      :f => demand_x[:f]*pax,
      :j => demand_x[:j]*pax,
      :p => demand_x[:p]*pax,
      :y => demand_x[:y]*pax
    }
    if continium > 1
      fares[:f] = fares[:f]*continium
      demand[:f] = demand[:f]*continium
      fares[:j] = (fares[:j]*([continium,continium*0.9].max))
      demand[:j] = (demand[:j]*([continium,continium*0.9].max))
      fares[:y] = (fares[:y]*(2.0-continium))
      demand[:y] = (demand[:y]*(2.0-continium))
    elsif continium < 1
      fares[:f] = fares[:f]*continium
      demand[:f] = demand[:f]*continium
      fares[:j] = (fares[:j]*([continium,continium*0.9].max))
      demand[:j] = (demand[:j]*([continium,continium*0.9].max))
      fares[:y] = (fares[:y]*(2.0-continium))
      demand[:y] = (demand[:y]*(2.0-continium))
    end
    data = {
      :demand => {
        y:demand[:y].round,
        p:demand[:p].round,
        j:demand[:j].round,
        f:demand[:f].round
      },
      :price => {
        y:fares[:y].round,
        p:fares[:p].round,
        j:fares[:j].round,
        f:fares[:f].round
      }
    }
  end

  def return_dist origin, dest
    lat_a = origin.latitude.to_f
    lng_a = origin.longitude.to_f

    lat_b = dest.latitude.to_f
    lng_b = dest.longitude.to_f

    mi = (gcm_distance([lat_a, lng_a], [lat_b, lng_b])*0.621371)
    min = {
      :y => (mi*0.1*0.3).round,
      :p => (mi*0.3*0.3).round,
      :j => (mi*0.5*0.3).round,
      :f => (mi*1.0*0.3).round
    }
    max = {
      :y => (mi*0.1*2.0).round+1000,
      :p => (mi*0.3*2.0).round+1000,
      :j => (mi*0.5*2.0).round+1000,
      :f => (mi*1.0*2.0).round+1000
    }
    return {
      :distance => mi,
      :min => min,
      :max => max
    }
  end

  def gcm_distance loc1, loc2
    lat1, lon1 = loc1
    lat2, lon2 = loc2
    dLat = (((lat2-lat1)*Math::PI) / 180);
    dLon = (((lon2-lon1)*Math::PI) / 180);
    a = Math.sin(dLat/2) * Math.sin(dLat/2) +
    Math.cos((lat1 * Math::PI / 180)) * Math.cos((lat2 * Math::PI / 180)) *
    Math.sin(dLon/2) * Math.sin(dLon/2);
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    d = 6371 * c;
  end
  
end
