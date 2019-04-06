module Mutations
  MutationType = GraphQL::ObjectType.define do
    name "Mutation"
    field :saveTrip,      field: SaveTrip.field
  end
end
