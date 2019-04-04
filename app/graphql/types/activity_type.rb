Types::ActivityType = GraphQL::ObjectType.define do
  name "Activity"
  field :event_type, types.String
  field :title, types.String
  field :price, types.String
end
