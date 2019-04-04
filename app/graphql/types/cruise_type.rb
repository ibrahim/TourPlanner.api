Types::CruiseType = GraphQL::ObjectType.define do
  name "Cruise"
  field :event_type, types.String
  field :title, types.String
  field :price, types.String
end
