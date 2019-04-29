Types::QueryType = GraphQL::ObjectType.define do
  name "Query"
  # Add root-level fields here.
  # They will be entry points for queries on your schema.

  field :current_user, !Types::UserType do
    description "Current Authenticated User"
    # argument :domain, !types.String
    resolve ->(obj, args, ctx) {
      # domain = Domain.where(name: args[:domain]).reorder(nil).first
      # site = domain.site unless domain.blank?
      # site = Site.where(name: args[:name]).first
      # Decode token and return user
    unless ctx[:current_user]
      error = GraphQL::ExecutionError.new("Unauthorized Access Denied") 
      ctx.add_error(error)
      return
    end
      # # raise GraphQL::ExecutionError.new e.message
      ctx[:current_user]
      # User.first
    }
  end
end
