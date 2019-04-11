class Guides::Category
  include Mongoid::Document

  field :name, type: String
  field :slug, type: String
  field :full_url, type: String
  field :description, type: String
  belongs_to :city
  
  has_many :attractions

  index({ slug: 1, city_id: 1}, {unique: true})
  
  attr_accessor :result

  def fetch
    category_url = full_url
    domain_name = "https://www.arrivalguides.com"
    path_url = full_url.gsub(domain_name,"")
    @result = Wombat.crawl do
      base_url domain_name
      path path_url
      slug category_url.to_s.split("/").last
      full_url category_url
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

  def fetch_and_save_all
    fetch
    save
    save_attractions
  end

  def save_attractions
    raise "Category must be saved first before adding attractions" if new_record?
    @result["attractions"].each do |attraction|
      begin
        Guides::Attraction.create!(
          name: attraction["name"], 
          slug: attraction["full_url"].split("/").last,
          thumb: attraction["thumb"], 
          full_url: attraction["full_url"], 
          description: attraction["description"],
          city: city,
          category: self
        )
      rescue
        File.open(Rails.root.join(), 'w') { |file| file.write("your text") }
      end
    end
  end
end
