Types::SnippetType = GraphQL::UnionType.define do
  name "Snippet"
  possible_types [
    Types::PlaceType,
    Types::InfoType
  ]
  resolve_type -> (object, ctx) do
    case object.class.name
      when "Snippet::Base"
        Types::SnippetType
      when "Snippet::Info"
        Types::InfoType
      when "Snippet::Place"
        Types::PlaceType
    end
  end
end
