module Mutations
    SaveTrip = GraphQL::Relay::Mutation.define do
        name "SaveTrip"

        input_field :uuid, types.String
        input_field :status, types.Int
        input_field :name, types.String
        input_field :price, types.String
        input_field :start_at, types.String
        input_field :description, types.String
        input_field :download_pdf, types.Boolean
        input_field :messaging, types.Boolean
        input_field :overview_map, types.Boolean

        return_field :trip, Types::TripType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do

          return GraphQL::ExecutionError.new("Unauthorized Access Denied") if ctx[:current_user].blank?

          trip = inputs[:uuid].present? ? Trip.find(inputs[:uuid]).first : Trip.new
          return GraphQL::ExecutionError.new("Trip Not Found") if trip.blank?
          trip_attributes = {
            status:        inputs[:status],
            user:          ctx[:current_user],
            name:          inputs[:name],
            start_at:      inputs[:start_at],
            price:         inputs[:price],
            description:   inputs[:description],
            download_pdf:  inputs[:download_pdf],
            messaging:     inputs[:messaging],
            overview_map:  inputs[:overview_map]
          }
          if trip.update_attributes(trip_attributes)
            return { 
              trip: trip,
            }
          else
            GraphQL::ExecutionError.new("Unable to save trip.#{trip.errors.messages.map{|k,v| " #{k} #{v.join(",")}."}.join(". ")}")
          end
        end
    end
end
