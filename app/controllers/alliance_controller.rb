class AllianceController < ApplicationController

  def all
    alliances = Alliance.all
    alliance_list = []
    alliances.each do |alliance|
      alliance = {
        name:alliance.name,
        id:alliance.id,
        airlines:alliance.airlines.length
      }
      alliance_list.push(alliance)
    end
    render json: alliance_list
  end

  def create
    params[:alliance] = {
      game_id:params[:game_id],
      name:params[:name]
    }
    user = User.find(cookies.signed[:airtycoon_user])
    airline = user.airlines.where({game_id:params[:game_id]})[0]
    if airline.alliance
      alliance = airline.alliance
      if airline.alliance_membership.status == false
        alliance = {
          name:alliance.name,
          id:alliance.id,
          message:'airline already in alliance'
        }
      else
        alliance = {
          name:alliance.name,
          id:alliance.id,
          message:'airline pending acceptance into alliance'
        }
      end
    else
      alliance = Alliance.new(alliance_params)
      if alliance.save
        membership = AllianceMembership.new({alliance_id:alliance.id,airline_id:airline.id,status:true,position:1})
        membership.save
        alliance = {
          name:alliance.name,
          id:alliance.id,
          airlines:[
            {
              name:airline.name,
              id:airline.id,
              icao:airline.icao
            }
          ],
          message:'alliance created'
        }
      else
        alliance = alliance.errors.messages
      end
    end
    render json: alliance
  end

  def show
    alliance = Alliance.find(params[:id])
    user_airline = User.find(cookies.signed[:airtycoon_user]).airlines.where({game_id:alliance.game_id})[0]
    airlines = []
    alliance.airlines do |airline|
      this_airline = {
        name:airline.name,
        icao:airline.icao,
        id:airline.id,
        position:airline.alliance_membership.position
      }
      if user_airline.membership_status == 1 && user_airline.alliance == alliance
        this_airline[:status] = airline.status
      end
      airlines.push(this_airline)
    end
    alliance = {
      name:alliance.name,
      id:alliance.name,
      airlines:airlines
    }
    render json: alliance
  end

  def request_membership
    alliance = Alliance.find(params[:id])
    airline = User.find(cookies.signed[:airtycoon_user]).airlines.where({game_id:alliance.game_id})[0]
    if airline.alliance
      if airline.alliance_membership.status
        alliance = {
          name:alliance.name,
          id:alliance.id,
          message:'airline already in alliance'
        }
      else
        alliance = {
          name:alliance.name,
          id:alliance.id,
          message:'airline pending acceptance into alliance'
        }
      end
    else
      airline.alliance = alliance
      alliance = {
        name:alliance.name,
        id:alliance.id,
        message:'membership requested'
      }
    end
    render json: alliance
  end

  def approve_membership
    alliance = Alliance.find(params[:id])
    airline = User.find(cookies.signed[:airtycoon_user]).airlines.where({game_id:alliance.game_id})[0]
    if airline.alliance_membership.status && airline.alliance_membership.position == 1
      member = AllianceMembership.find(params[:membership_id])
      requestor = Airline.find(member.airline_id)
      alliance_membership = member.update({position:2,status:true})
      if alliance_membership
        membership = {
          airline:{
            name:requestor.name,
            icao:requestor.icao,
            id:requestor.id
          },
          alliance:{
            name:alliance.name,
            id:alliance.id
          },
          status:true,
          position:2,
          id:requestor.alliance_membership.status
        }
      else
        membership = alliance_membership.errors.messages
      end
    else
      membership = {
        error:'Airline does not have permission'
      }
    end
    render json: membership
  end

  private
  def alliance_params
    params.require(:alliance).permit(:name, :game_id)
  end
  def request_params
    params.require(:alliance).permit(:id, :airline_id)
  end

end
