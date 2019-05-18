module Mutations
    SaveEvent = GraphQL::Relay::Mutation.define do
        name "SaveEvent"

        #Required Fields
        input_field  :trip_id,   !types.String
        input_field  :_type,     !types.String
        input_field  :section_id,    !types.String

        #Optional Fields
        input_field  :uuid,      types.String
        input_field  :title,     types.String
        input_field  :notes,     types.String
        input_field  :price,     types.Int
        input_field  :currency,  types.String
        input_field  :starts_at, types.Float
        input_field  :duration,  types.Int
        input_field  :day,       types.Int
        input_field  :booked_through,     types.String
        input_field  :confirmation,     types.String
        input_field  :provider,     types.String
        input_field  :airline,     types.String
        input_field  :flight_number,     types.String
        input_field  :terminal,     types.String
        input_field  :gate,     types.String
        input_field  :cabin_type,     types.String
        input_field  :cabin_number,     types.String
        input_field  :phone_number,     types.String
        input_field  :carrier,     types.String
        input_field  :info_type,     types.String

        return_field :user, !Types::UserType
        return_field :errors, types.String

        resolve -> (object, inputs, ctx) do

          return GraphQL::ExecutionError.new("Unauthorized Access Denied") if ctx[:current_user].blank?

          trip =  Trip.find(inputs[:trip_id]).first #if inputs[:trip_id].present?
          return GraphQL::ExecutionError.new("Cannot Save Event: Parent Trip Not Found.") if trip.blank?
          
          section =  trip.sections.where(uuid: inputs[:section_id]).first #if inputs[:day].present?
          return GraphQL::ExecutionError.new("Cannot Save Event: Parent Section Not Found.") if section.blank?

          return GraphQL::ExecutionError.new("Event Type Not Identified")  unless inputs[:_type].present?

          model = inputs[:_type].constantize
          # associations = inputs[:_type].split("::").last.downcase.pluralize.to_sym
          associations = trip.association_for(inputs[:_type])
          event = inputs[:uuid] ? associations.where(uuid: inputs[:uuid]).first : model.new
          return GraphQL::ExecutionError.new("Event Not Found") if event.blank?
          
          type_name = inputs[:_type].split(":").last
          graphql_type = ("Types::%sType" % [ type_name ]).constantize
          attrs = {} 
          graphql_type.fields.keys.each do |k|
            attrs[k] = inputs[k] unless ["section_id","uuid","_type","snippets"].include?(k)
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
          event.title = inputs[:title] if inputs[:title].present?
          event.title = type_name.capitalize if event.new_record?

          event.price = inputs[:price] if inputs[:price].present?
          event.currency = inputs[:currency] if inputs[:currency].present?
          event.notes = inputs[:notes] if inputs[:notes].present?
          event.airline = inputs[:airline] if inputs[:airline].present?
          event.flight_number = inputs[:flight_number] if inputs[:flight_number].present?
          event.terminal = inputs[:terminal] if inputs[:terminal].present?
          event.provider = inputs[:provider] if inputs[:provider].present?
          event.phone_number = inputs[:phone_number] if inputs[:phone_number].present?
          event.gate = inputs[:gate] if inputs[:gate].present?
          event.cabin_type = inputs[:cabin_type] if inputs[:cabin_type].present?
          event.cabin_number = inputs[:cabin_number] if inputs[:cabin_number].present?
          event.starts_at = inputs[:starts_at] if inputs[:starts_at].present?
          event.duration = inputs[:duration] if inputs[:duration].present?
          event.booked_through = inputs[:booked_through] if inputs[:booked_through].present?
          event.confirmation = inputs[:confirmation] if inputs[:confirmation].present?
          event.info_type = inputs[:info_type] if inputs[:info_type].present?

          event.trip = trip if event.new_record?
          event.section = section
          if event.save!
            return { 
              user: ctx[:current_user],
            }
          else
            GraphQL::ExecutionError.new("Unable to save event.#{event.errors.messages.map{|k,v| " #{k} #{v.join(",")}."}.join(". ")}")
          end
        end
    end
end
