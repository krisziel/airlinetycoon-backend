namespace :turn do
  desc "Monthly distribution of passengers"
  task month: :environment do
  	require 'turn'
  	turn = Turn.new
  	Game.all.each do |game|
  		turn.game_flights(game.id)
  	end
  end

  task fares: :environment do
  	require 'fare_turn'
  	turn = FareTurn.new
  	turn.game_fares(2)
  end

end
