class Guides::Attraction
  include Mongoid::Document

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "guides_attractions"
  def as_indexed_json(options={})
    self.as_json({only: [:name, :description]}) 
  end 

  field :name, type: String
  field :thumb, type: String
  field :slug, type: String
  field :full_url, type: String
  field :description, type: String

  belongs_to :city, index: true
  belongs_to :category, index: true

  validates_presence_of :full_url, :name, :slug
  index({ slug: 1, city: 1, category: 1 },{ unique: true })
  # index { continent: 1}


end
