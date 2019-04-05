Types::InformationType = GraphQL::ObjectType.define do
  name "Information"
  field :_type, types.String, property: :__type
  field :title, types.String
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
