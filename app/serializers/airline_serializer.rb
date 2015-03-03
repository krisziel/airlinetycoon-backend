class AirlineSerializer < ActiveModel::Serializer
  attributes :id, :name, :icao, :money, :game_id, :alliance
end
