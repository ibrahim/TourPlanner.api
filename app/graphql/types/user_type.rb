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
end
