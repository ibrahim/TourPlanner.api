class Guides::Attraction
  include Mongoid::Document
  include Mongoid::Geospatial

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

  field :address, type: String
  field :place_id, type: String
  field :location, type: Point

  spatial_index :location

  belongs_to :city, index: true
  belongs_to :category, index: true

  validates_presence_of :full_url, :name, :slug
  index({ slug: 1, city: 1, category: 1 },{ unique: true })
  # index { continent: 1}

  def fetch
    attraction_url = self.full_url
    domain_name = "https://www.arrivalguides.com"
    path_url = full_url.gsub(domain_name,"")
    @result = Wombat.crawl do
      base_url domain_name
      path path_url
      slug category_url.to_s.split("/").last
      full_url attraction_url
      name css: ".facts-header .facts-title"
      description xpath: "//div[@class='content-info']/text()[normalize-space(.) != '']"
      country css: ".breadcrumbs-links a:nth-child(2)"
      city css: ".breadcrumbs-links a:nth-child(3)"
      attractions "css=.main-container .tile-group article", :iterator do 
        full_url xpath: "./a/@href"
        thumb({ xpath: "./a/figure/img/@src" })
        name 'css=a div[class^="tileOverlay"] h2'
        description 'css=a div[class^="tileOverlay"] div div[class^="tileContent"]'
      end
    end
    self.description = @result["description"]
    self.slug = @result["slug"]
    self.name = @result["name"]
    @result
  end


end
