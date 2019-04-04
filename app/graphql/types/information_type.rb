Types::InformationType = GraphQL::ObjectType.define do
  name "Information"
  field :event_type, types.String
  field :title, types.String
end
