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
  resolve_type -> (object, ctx) do
    case object.class.name
      when "Event::Activity"
        Types::ActivityType
      when "Event::Lodging"
        Types::LodgingType
      when "Event::Flight"
        Types::FlightType
      when "Event::Transportation"
        Types::TransportationType
      when "Event::Cruise"
        Types::CruiseType
      when "Event::Information"
        Types::InformationType
    end
  end
end
