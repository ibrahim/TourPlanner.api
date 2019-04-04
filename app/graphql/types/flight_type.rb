Types::FlightType = GraphQL::ObjectType.define do
  name "Flight"
  field :event_type, types.String
  field :title, types.String
  field :price, types.String
end
