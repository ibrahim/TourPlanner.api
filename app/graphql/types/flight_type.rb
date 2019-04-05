Types::FlightType = GraphQL::ObjectType.define do
  name "Flight"
  field :_type, types.String, property: :__type
  field :title, types.String
  field :price, types.String
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
