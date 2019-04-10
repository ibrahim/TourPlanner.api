class CategoryFetcher < GuideFetcher

  def initialize(category, url)
    @category = category
    @url = url
  end
  
  def fetch
    category = @category
    url = @url
    domain_name = "https://www.arrivalguides.com"
    path_url = url.gsub(domain_name,"")
    Wombat.crawl do
      base_url domain_name
      path path_url
      name category
      slug url.to_s.split("/").last
      full_url url
      title css: ".facts-header .facts-title"
      description xpath: "//div[@class='content-info']/text()[normalize-space(.) != '']"
      country css: ".breadcrumbs-links a:nth-child(2)"
      city css: ".breadcrumbs-links a:nth-child(3)"
      attractions "css=.main-container .tile-group article", :iterator do 
        full_url xpath: "./a/@href"
        thumb({ xpath: "./a/figure/img/@src" })
        name "css=a .tileOverlay h2"
        description "css=a .tileOverlay .tileContentNoSlide"
      end
    end
  end

  def fetch_and_save
    save(fetch)
  end

  def save(data)
    Guides::City.where(name: @country)
  end

  def self.save_attractions(data)
    slug = data["full_url"].split("/").last
    country = Guides::Country.where({name: data["country"]}).first
    raise "Save Attractions: City data does not contain country name." if country.blank?
    city = country.cities.where(name: data["city"]).first
    raise "Cannot save city facts. City not saved yet or not found." if city.blank?
    current_category = city.categories.where(slug: slug).first
    data["attractions"].each do |attraction|
      Guides::Attraction.create!(
        name: attraction["name"], 
        slug: attraction["full_url"].split("/").last,
        thumb: attraction["thumb"], 
        full_url: attraction["full_url"], 
        description: attraction["description"],
        city: city,
        category: current_category
      )
    end
    return current_category.attractions
  end
end
