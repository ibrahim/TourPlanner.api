Types::InformationType = GraphQL::ObjectType.define do
  name "Information"
  field :uuid, !types.String
  field :_type, !types.String, property: :type
  field :title, !types.String
  field :notes, types.String
  field :day, types.Int
  field :snippets, types[Types::SnippetType] do
    resolve ->(event, args, ctx) {
      event.snippets.all
    }
  end
end
