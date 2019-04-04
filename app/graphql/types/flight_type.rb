Types::FlightType = GraphQL::ObjectType.define do
  name "Flight"
  field :title, types.String
  field :price, types.String
end
