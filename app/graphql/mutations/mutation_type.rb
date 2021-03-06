module Mutations
  MutationType = GraphQL::ObjectType.define do
    name "Mutation"
    field :saveTrip,     field: SaveTrip.field
    field :saveEvent,    field: SaveEvent.field
    field :deleteEvent,  field: DeleteEvent.field
    field :saveSection,  field: SaveSection.field
  end
end
