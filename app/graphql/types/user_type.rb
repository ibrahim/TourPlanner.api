Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :id, !types.ID
  field :email, !types.String

  field :trips, !types[!Types::TripType] do
    argument :status, types.String
    argument :limit, types.Int
    argument :uuid, types.String
    # preload  :frames
    resolve ->(user, args, ctx) {
        trips = user.trips 
        trips = trips.where(uuid: args[:uuid]) if args[:uuid].present?
        trips.all
        #.sort{|a,b| a.lft <=> b.lft}
    }
  end
  field :event, Types::EventType do
    description "Event type"
    argument :uuid, types.String
    argument :trip_id, types.String
    resolve ->(user, args, ctx) {
      return nil if args[:uuid].blank?
      return nil if args[:trip_id].blank?
      trip = user.trips.where(uuid: args[:trip_id]).first
      event = trip.events.where(uuid: args[:uuid]).first
    }
  end
end
