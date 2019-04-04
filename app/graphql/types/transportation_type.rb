Types::TransportationType = GraphQL::ObjectType.define do
  name "Transportation"
  field :title, types.String
  field :price, types.String
end
