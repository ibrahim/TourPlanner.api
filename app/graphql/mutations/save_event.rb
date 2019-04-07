module Mutations
    SaveEvent = GraphQL::Relay::Mutation.define do
        name "SaveEvent"

        input_field  :uuid,      types.String
        input_field  :_type,     types.String
        input_field  :title,     types.String
        input_field  :notes,     types.String
        input_field  :price,     types.Int
        input_field  :currency,  types.String
        input_field  :starts_at,  types.String
        input_field  :duration,  types.Int
        input_field  :day,       types.Int
        input_field  :trip_id,   types.String

        return_field :event, Types::EventType
        return_field :errors, types.String

        resolve ->(object, inputs, ctx) do

          return GraphQL::ExecutionError.new("Unauthorized Access Denied") if ctx[:current_user].blank?

          trip =  Trip.find(inputs[:trip_id]).first if inputs[:trip_id].present?
          return GraphQL::ExecutionError.new("Cannot Save Event: Parent Trip Not Found.") if trip.blank?
          
          return GraphQL::ExecutionError.new("Event Type Not Identified")  unless inputs[:_type].present?
          model = inputs[:_type].constantize
          type = ("Types::%sType" % [ inputs[:_type].split(":").last ]).constantize
          event = inputs[:uuid] ? model.find(inputs[:uuid]).first : model.new
          return GraphQL::ExecutionError.new("Event Not Found") if event.blank?
          attrs = {} 
          type.fields.keys.each do |k|
            attrs[k] = inputs[k] unless ["uuid","_type","snippets"].include?(k)
          end
          # attrs = {
          #   title:     inputs[:title],
          #   notes:     inputs[:notes],
          #   day:       inputs[:day]
          # }
          # unless ["Event::Information"].include?(event.type)
          #   attrs[:price]     = inputs[:price]
          #   attrs[:currency]  = inputs[:currency]
          #   attrs[:duration]  = inputs[:duration]
          #   attrs[:starts_at] = inputs[:starts_at]
          # end
          event.trip_id = trip.id if event.new_record?
          if event.update_attributes(attrs)
            return { 
              event: event,
            }
          else
            GraphQL::ExecutionError.new("Unable to save trip.#{event.errors.messages.map{|k,v| " #{k} #{v.join(",")}."}.join(". ")}")
          end
        end
    end
end
