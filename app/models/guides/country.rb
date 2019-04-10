class Guides::Country
  include Mongoid::Document

  field :name, type: String
  field :slug, type: String
  field :thumb, type: String
  field :full_url, type: String
  field :description, type: String
  field :continent, type: String

  has_many :cities
  index({ name: 1 },{ unique: true })
  # index { continent: 1}

  def fetch
    raise "Country url is not defined" if full_url.blank?
    domain = "https://www.arrivalguides.com"
    path_url = full_url.gsub(domain, "")
    result = Wombat.crawl do
      base_url domain
      path path_url
      name css: ".country-text h1"
      continent css: ".country-text a h3"
      slug full_url.split("/").last
      full_url full_url
      cities "css=.left-content-holder article", :iterator do
        name  css: ".content-list-text h2 a"
        thumb({ xpath: "./figure/a/img/@src" })
        full_url({ xpath: "./div/h2/a/@href" })
        description css: ".list-info"
      end
    end
    name = result["name"]
    full_url = result["full_url"]
    slug = result["slug"]
    continent = result["continent"]
    result
  end

  def save_country(data)
    c = Guides::Country.new
    c.name = data["name"]
    c.slug = data["slug"]
    c.thumb = data["thumb"]
    c.description = data["description"]
    c.continent = data["continent"]
    c.full_url = data["full_url"]
    c.upsert
  end

  def self.save_cities(data)
    country = Guides::Country.where({name: data["name"]}).first
    Raise "Cannot save cities. Country not saved yet or not found" unless country
    cities = data["cities"] 
    cities.each do |c|
      city = Guides::City.new
      city.country = country
      city.name = c["name"]
      city.full_url = c["full_url"]
      city.upsert
    end
  end
end
