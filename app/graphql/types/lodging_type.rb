Types::LodgingType = GraphQL::ObjectType.define do
  name "Lodging"
  field :title, types.String
  field :price, types.String
end
