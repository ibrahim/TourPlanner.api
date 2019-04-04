Types::TripType = GraphQL::ObjectType.define do
  name "Trip"
  field :status, types.Int
  field :name, types.String
  field :start_at, types.String
  field :price, types.String
  field :description, types.String
  field :download_pdf, types.Boolean
  field :messaging, types.Boolean
  field :overview_map, types.Boolean

  field :events, types[Types::EventType] do
    # argument :status, types.String
    # argument :limit, types.Int
    # preload  :frames
    resolve ->(trip, args, ctx) {
      trip.events.all
    }
  end
end
