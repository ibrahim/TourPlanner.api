Types::LodgingType = GraphQL::ObjectType.define do
  name "Lodging"
  field :event_type, types.String
  field :title, types.String
  field :price, types.String
end
