Types::DiningType = GraphQL::ObjectType.define do
  name "Dining"
  field :uuid, types.String
  field :_type, types.String, property: :type
  field :title, types.String
  field :notes, types.String
  field :price, types.Int
  field :starts_at, types.String
  field :currency, types.String
  field :duration, types.Int
  field :day, types.Int
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
