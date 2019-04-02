Types::Trip::TripType = GraphQL::ObjectType.define do
  name "Trip"
  field :status, types.Int
  field :name, types.String
  field :start_at, Types::DateType
  field :price, types.String
  field :description, types.String
  field :download_pdf, types.Boolean
  field :messaging, types.Boolean
  field :overview_map, types.Boolean
end
