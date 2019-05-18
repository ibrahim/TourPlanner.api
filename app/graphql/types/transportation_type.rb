Types::TransportationType = GraphQL::ObjectType.define do
  name "Transportation"
  field :uuid, !types.String
  field :section_id, !types.String, property: :section_uuid
  field :_type, !types.String, property: :type
  field :title, types.String
  field :notes, types.String
  field :price, types.Int
  field :starts_at, types.Float
  field :currency, types.String
  field :duration, types.Int
  field :booked_through, types.String
  field :confirmation, types.String
  field :carrier, types.String
  field :phone_number, types.String
  field :day, types.Int
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
