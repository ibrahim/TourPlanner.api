class Guides::Country
  include Mongoid::Document

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  index_name "guides_countries"
  def as_indexed_json(options={})
    self.as_json({only: [:name, :description, :continent_id]}) 
  end 

  field :name, type: String
  field :slug, type: String
  field :thumb, type: String
  field :full_url, type: String
  field :description, type: String
  # field :continent, type: String
  belongs_to :continent

  has_many :cities
  index({ name: 1 },{ unique: true })
  # index { continent: 1}


  attr_accessor :result

  def fetch
    raise "Country url is not defined" if full_url.blank?
    domain = "https://www.arrivalguides.com"
    path_url = full_url.gsub(domain, "")
    country_url = full_url
    @result = Wombat.crawl do
      base_url domain
      path path_url
      name css: ".country-text h1"
      continent css: ".country-text a h3"
      slug country_url.split("/").last
      full_url country_url
      cities "css=.left-content-holder article", :iterator do
        name  css: ".content-list-text h2 a"
        thumb({ xpath: "./figure/a/img/@src" })
        full_url({ xpath: "./div/h2/a/@href" })
        description css: ".list-info"
      end
    end
    self.name = @result["name"]
    self.full_url = @result["full_url"]
    self.slug = @result["slug"]
    @result
  end

  def fetch_and_save_all
    fetch
    save
    save_cities
  end

  def save_cities
    Raise "Cannot save cities. Country not saved yet or not found" if new_record?
    result["cities"].each do |c|
      city = Guides::City.new
      city.country = self
      city.name = c["name"]
      city.full_url = c["full_url"]
      city.upsert
    end
  end
end
