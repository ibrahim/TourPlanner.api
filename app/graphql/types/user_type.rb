Types::UserType = GraphQL::ObjectType.define do
  name "User"
  field :id, types.ID
  field :email, types.String

  field :trips, types[Types::TripType] do
    argument :status, types.String
    argument :limit, types.Int
    # preload  :frames
    resolve ->(user, args, ctx) {
        user.trips #.sort{|a,b| a.lft <=> b.lft}
    }
  end
end
