module Mutations
    DeleteEvent = GraphQL::Relay::Mutation.define do
        name "DeleteEvent"

        #Required Fields
        input_field  :trip_id,   !types.String
        input_field  :uuid,      !types.String

        return_field :user, !Types::UserType
        return_field :errors, types.String

        resolve -> (object, inputs, ctx) do

          return GraphQL::ExecutionError.new("Unauthorized Access Denied") if ctx[:current_user].blank?

          trip =  Trip.find(inputs[:trip_id]).first #if inputs[:trip_id].present?
          return GraphQL::ExecutionError.new("Cannot Save Event: Parent Trip Not Found.") if trip.blank?
          

          event = Event::Base.find(inputs[:uuid]).first
          return GraphQL::ExecutionError.new("Event Not Found") if event.blank?
          return GraphQL::ExecutionError.new("Event Not Found for this trip") if event.trip != trip
          
          if event.destroy
            return { 
              user: ctx[:current_user],
            }
          else
            GraphQL::ExecutionError.new("Unable to delete event.#{event.errors.messages.map{|k,v| " #{k} #{v.join(",")}."}.join(". ")}")
          end
        end
    end
end
