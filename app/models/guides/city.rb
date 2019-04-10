class Guides::City
  include Mongoid::Document

  field :name, type: String
  field :thumb, type: String
  field :slug, type: String
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

  attr_accessor :result

  # has_many :cities
  index({ name: 1, country: 1},{ unique: true })
  # index { continent: 1}
  
  def fetch
    city_url = full_url
    domain_name = "https://www.arrivalguides.com"
    @result = Wombat.crawl do
      path_url = city_url.gsub(domain_name,"")
      base_url domain_name
      path path_url
      full_url city_url
      slug city_url.split("/").last
      name css: ".hero-text h1"
      country css: ".hero-text h3"
      last_updated css: ".guide-date time"
      categories "css=.left-navi-block.slideMenu ul li.category", :iterator do
        name  css: "a"
        full_url({ xpath: "./a/@href" })
      end
      facts "css=.overview-pre-expand table tr", :iterator do
        name "css=td.label"
        info "css=td:last-child"
      end
      tags "css=.facts-header a.theme-dest-link", :list
    end
    @result["categories"] = @result["categories"].reject{|c| c["name"] =~ /Hotels/}
    self.slug = @result["slug"]
    self.last_updated = @result["last_updated"]
    @result
  end

  def save_facts
    raise "City must be saved first before adding facts" if new_record?
    @result["facts"].each do |fact|
      facts.create(name: fact["name"], info: fact["info"])
    end
  end

  def save_categories
    raise "City must be saved first before adding categories" if new_record?
    @result["categories"].each do |c|
      slug = c["full_url"].to_s.split("/").last
      categories.create(slug: slug, full_url: c["full_url"], description: c["description"], city: self)
    end
  end
end
