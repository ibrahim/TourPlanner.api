Types::ActivityType = GraphQL::ObjectType.define do
  name "Activity"
  field :uuid, !types.String
  field :section_id, !types.String, property: :section_uuid
  field :_type, !types.String, property: :type
  field :title, types.String
  field :notes, types.String
  field :price, types.Int
  field :currency, types.String
  field :starts_at, types.Float
  field :ends_at, types.Float
  # field :starts_at, types[Types::ISO8601DateTime]#types.Float #GraphQL::Types::ISO8601DateTime, null: false
  field :duration, types.Int

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
# class Types::ActivityType < GraphQL::Schema::Object
#   graphql_name "Activity"
#   field :uuid,            String,                           null: true
#   field :section_id,      String,                           null: false,  method: :section_uuid
#   field :_type,           String,                           null: false,  method: :type
#   field :booked_through,  String,                           null: true
#   field :title,           String,                           null: true
#   field :notes,           String,                           null: true
#   field :price,           Integer,                          null: true
#   field :currency,        String,                           null: true
#   field :starts_at,       GraphQL::Types::ISO8601DateTime,  null: false
#   field :duration,        Integer,                          null: true
#
#   field :confirmation,    String,                           null: true
#   field :provider,        String,                           null: true
#
#   field :day,             Integer,                          null: true
#   field :snippets,        [Types::SnippetType],             null: false,  resolve: -> (event,    args,  ctx) {
#       event.snippets.all
#   }
# end
