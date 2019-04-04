Types::CruiseType = GraphQL::ObjectType.define do
  name "Cruise"
  field :title, types.String
  field :price, types.String
end
