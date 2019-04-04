# class Types::BaseUnion < GraphQL::Schema::Union
Types::EventType = GraphQL::UnionType.define do
  name "Event"
  possible_types [
    Types::ActivityType, 
    Types::LodgingType, 
    Types::FlightType, 
    Types::TransportationType, 
    Types::CruiseType, 
    Types::InformationType
  ]
end
