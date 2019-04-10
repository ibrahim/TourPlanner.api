class Guides::Category
  include Mongoid::Document

  field :name, type: String
  field :slug, type: String
  field :full_url, type: String
  field :description, type: String
  belongs_to :city
  
  has_many :attractions

  index({ slug: 1, city_id: 1}, {unique: true})
end
