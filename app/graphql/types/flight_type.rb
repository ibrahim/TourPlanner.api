Types::FlightType = GraphQL::ObjectType.define do
  name "Flight"
  field :uuid, types.String
  field :_type, types.String, property: :type
  field :title, !types.String
  field :notes, types.String
  field :starts_at, types.String
  field :duration, types.Int
  field :day, types.Int
  field :price, types.Int
  field :currency, types.String
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
