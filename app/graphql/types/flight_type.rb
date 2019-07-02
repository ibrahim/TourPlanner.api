Types::FlightType = GraphQL::ObjectType.define do
  name "Flight"
  field :uuid, !types.String
  field :section_id, !types.String, property: :section_uuid
  field :_type, !types.String, property: :type
  field :title, types.String
  field :notes, types.String
  field :starts_at, types.Float
  field :ends_at, types.Float
  field :duration, types.Int
  field :day, types.Int
  field :price, types.Int
  field :currency, types.String
  field :booked_through, types.String
  field :confirmation, types.String
  field :airline, types.String
  field :flight_number, types.String
  field :terminal, types.String
  field :gate, types.String
  field :snippets, types[Types::SnippetType] do
    resolve -> (event, args, ctx) {
      event.snippets.all
    }
  end
end
