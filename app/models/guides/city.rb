class Guides::City
  include Mongoid::Document

  field :name, type: String
  field :thumb, type: String
  field :full_url, type: String
  field :description, type: String
  field :last_updated, type: String
 
  belongs_to :country, index: true
  embeds_many :facts
  has_many :categories do
    def by_slug(slug)
      where(slug: slug).first
    end
  end

  accepts_nested_attributes_for :categories

  # has_many :cities
  index({ name: 1, country: 1},{ unique: true })
  # index { continent: 1}
end
