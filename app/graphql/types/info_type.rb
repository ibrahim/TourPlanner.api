Types::InfoType = GraphQL::ObjectType.define do
  name "Info"
  field :_type, types.String, property: :__type
  field :title,  types.String
  field :description, types.String
  field :icon,  types.String
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
