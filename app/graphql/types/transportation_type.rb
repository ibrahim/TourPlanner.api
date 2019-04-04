Types::TransportationType = GraphQL::ObjectType.define do
  name "Transportation"
  field :event_type, types.String
  field :title, types.String
  field :price, types.String
end
