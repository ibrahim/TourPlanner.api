class Guides::Attraction
  include Mongoid::Document

  field :name, type: String
  field :thumb, type: String
  field :slug, type: String
  field :full_url, type: String
  field :description, type: String

  belongs_to :city
  belongs_to :category

  validates_presence_of :full_url, :name, :slug
  index({ slug: 1, city: 1, category: 1 },{ unique: true })
  # index { continent: 1}
end
