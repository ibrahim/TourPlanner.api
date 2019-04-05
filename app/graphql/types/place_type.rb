Types::PlaceType = GraphQL::ObjectType.define do
  name "Place"
  field :_type, types.String, property: :__type
  field :title, types.String
  field :description, types.String
  field :vicinity, types.String
  field :lat, types.String
  field :lng, types.String
  field :name,  types.String
  field :icon,  types.String
  field :types,  types.String
  field :formatted_phone_number,  types.String
  field :formatted_address,  types.String
  field :address_components,  types.String
  field :rating,  types.String
  field :url,  types.String
  field :reference, types.String
end
