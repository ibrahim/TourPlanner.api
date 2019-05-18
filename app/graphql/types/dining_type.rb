Types::DiningType = GraphQL::ObjectType.define do
  name "Dining"
  field :uuid, !types.String
  field :section_id, !types.String, property: :section_uuid
  field :_type, !types.String, property: :type
  field :title, types.String
  field :notes, types.String
  field :starts_at, types.Float
  field :duration, types.Int
  field :price, types.Int
  field :currency, types.String
  field :booked_through, types.String
  field :confirmation, types.String
  field :provider, types.String
  field :day, types.Int
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
