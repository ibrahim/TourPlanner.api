Types::SectionType = GraphQL::ObjectType.define do
  name "Section"
  field :uuid, !types.String
  field :title, !types.String
  field :is_day, types.Boolean
  field :day_date, types.Int
  field :day_order, types.Int

end
