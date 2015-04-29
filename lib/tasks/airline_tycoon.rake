namespace :airline_tycoon do
  desc "Monthly distribution of passengers"
  task month_turn: :environment do
  	require 'turn'
  	turn = Turn.new
  	Game.all.each do |game|
  		turn.game_flights(game.id)
  	end
  end

end
