# require "apollo/tracing"

ApiSchema = GraphQL::Schema.define do
  # tracer GraphQL::Tracing::ActiveSupportNotificationsTracing
  use GraphQL::Backtrace
  use GraphQL::Batch
  # use ApolloTracing.new
  #query_execution_strategy GraphQL::Batch::ExecutionStrategy
  #enable_preloading
  # max_depth 12
  # max_complexity 200

  query Types::QueryType
  mutation Mutations::MutationType

  resolve_type ->(obj, ctx) do
    case obj.class.name
    when "Trip"
      Types::TripType
    when "User"
      Types::UserType
    when "Activity"
      Types::ActivityType
    when "Lodging"
      Types::LodgingType
    when "Flight"
      Types::FlightType
    when "Transportation"
      Types::TransportationType
    when "Cruise"
      Types::CruiseType
    when "Dining"
      Types::DiningType
    when "Information"
      Types::InformationType
    when "Place"
      Types::PlaceType
    when "Info"
      Types::InfoType
    else
      raise("Don't know how to get the GraphQL type of a #{obj.class.name} (#{obj.inspect})")
    end
  end
  #
  # object_from_id ->(id, ctx) do
  #   type_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
  #
  #   # This `find` gives the user unrestricted access to *all* the records in your app. In
  #   # a real world application you probably want to check if the user is allowed to access
  #   # the requested resource.
  #   type_name.constantize.find(item_id)
  # end
  #
  # id_from_object -> (object, type_definition, ctx) do
  #   GraphQL::Schema::UniqueWithinType.encode(type_definition.name, object.id)
  # end
end


ApiSchema.middleware << GraphQL::Schema::TimeoutMiddleware.new(max_seconds: 10) do |err, query|
  Rails.logger.info("GraphQL Timeout: #{query.query_string}")
end

log_query_complexity = GraphQL::Analysis::QueryComplexity.new { |query, complexity| Rails.logger.info("[GraphQL Query Complexity] #{complexity}")}
ApiSchema.query_analyzers << log_query_complexity

# ApiSchema.query_analyzers << GraphQL::Analysis::FieldUsage.new { |query, used_fields, used_deprecated_fields|
#   puts "Used GraphQL fields: #{used_fields.join(', ')}"
#   puts "Used deprecated GraphQL fields: #{used_deprecated_fields.join(', ')}"
# }


# GraphQL::Errors.configure(ApiSchema) do
#   rescue_from ActiveRecord::RecordNotFound do |exception|
#     nil
#   end
#
#   rescue_from ActiveRecord::RecordInvalid do |exception|
#     GraphQL::ExecutionError.new(exception.record.errors.full_messages.join("\n"))
#   end
#
#   rescue_from StandardError do |e|
#     GraphQL::ExecutionError.new e.message
#   end
#
#   # rescue_from CustomError do |exception, object, arguments, context|
#   #   error = GraphQL::ExecutionError.new("Error found!")
#   #   firstError.path = context.path + ["myError"]
#   #   context.add_error(firstError)
#   # end
# end
