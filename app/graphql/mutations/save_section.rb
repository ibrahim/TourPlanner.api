module Mutations
    SaveSection = GraphQL::Relay::Mutation.define do
        name "SaveSection"

        #Required Fields
        input_field  :trip_id,   !types.String
        input_field  :title,     !types.String

        #Optional Fields
        input_field  :uuid,      types.String
        input_field  :is_day,    types.Boolean
        input_field  :day_date,  types.Int
        input_field  :day_order, types.Int

        return_field :user, !Types::UserType
        return_field :errors, types.String

        resolve -> (object, inputs, ctx) do

          return GraphQL::ExecutionError.new("Unauthorized Access Denied") if ctx[:current_user].blank?

          trip =  Trip.find(inputs[:trip_id]).first #if inputs[:trip_id].present?
          return GraphQL::ExecutionError.new("Cannot Save Section: Parent Trip Not Found.") if trip.blank?
          
          section = inputs[:uuid] ? trip.sections.where(uuid: inputs[:uuid]).first : trip.sections.new
          return GraphQL::ExecutionError.new("Section Not Found") if inputs[:uuid].present? && section.blank?
          
          section.trip_id   = trip.id if section.new_record?
          section.title     = inputs[:title] if inputs[:title].present?
          section.day_order = inputs[:day_order] if inputs[:day_order].present?
          section.is_day    = inputs[:is_day] if inputs[:is_day].present?
          section.day_date  = inputs[:day_date] if inputs[:day_date].present?

          if section.save!
            return { 
              user: ctx[:current_user],
            }
          else
            return GraphQL::ExecutionError.new("Unable to save section.#{section.errors.messages.map{|k,v| " #{k} #{v.join(",")}."}.join(". ")}")
          end
        end
    end
end
