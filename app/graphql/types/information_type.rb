Types::InformationType = GraphQL::ObjectType.define do
  name "Information"
  field :title, types.String
end
