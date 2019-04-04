Types::ActivityType = GraphQL::ObjectType.define do
  name "Activity"
  field :title, types.String
  field :price, types.String
end
