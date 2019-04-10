class CityFetcher < GuideFetcher

  def initialize(city, url)
    @city = city
    @url = url
  end
  
  def fetch
    city = @city
    country = @country
    continent = @continent
    url = @url
    domain_name = "https://www.arrivalguides.com"
    Wombat.crawl do
      path_url = url.gsub(domain_name,"")
      base_url domain_name
      path path_url
      full_url url
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
  end

  def fetch_and_save
    save(fetch)
  end

  def self.save(data)
    Guides::City.where(name: @country)
  end

  def self.save_facts(data)
    country = Guides::Country.where({name: data["country"]}).first
    raise "City data does not contain country name." if country.blank?
    city = country.cities.where(name: data["name"]).first
    raise "Cannot save city facts. City not saved yet or not found." if city.blank?
    data["facts"].each do |fact|
      city.facts.create(name: fact["name"], info: fact["info"])
    end
    city.facts.length
  end

  def self.update_city(data)
    country = Guides::Country.where({name: data["country"]}).first
    raise "City data does not contain country name." if country.blank?
    city = country.cities.where(name: data["name"]).first
    city.last_updated = data["last_updated"]
    city.save
    return city
  end

  def self.save_categories(data)
    country = Guides::Country.where({name: data["country"]}).first
    raise "City data does not contain country name." if country.blank?
    city = country.cities.where(name: data["name"]).first
    raise "Cannot save city categories. City not saved yet or not found." if city.blank?
    categories = data["categories"].reject{|c| c["name"] =~ /Hotels/}
    categories.each do |c|
      slug = c["full_url"].to_s.split("/").last
      city.categories.create(slug: slug, full_url: c["full_url"], description: c["description"], city: city)
    end
    return city.categories
  end
end
