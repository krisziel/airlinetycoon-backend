namespace :turn do
  desc "Monthly distribution of passengers"
  task month: :environment do
  	require 'turn'
  	turn = Turn.new
  	turn.game_flights(2)
  	# Game.all.each do |game|
  	# 	turn.game_flights(game.id)
  	# end
  end

end
