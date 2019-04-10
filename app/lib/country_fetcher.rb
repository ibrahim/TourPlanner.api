class CountryFetcher < GuideFetcher

  def initialize(country, url)
    @country = country
    @url = url
  end
  
  def fetch
    country = @country
    url = @url
    domain = "https://www.arrivalguides.com"
    path_url = url.gsub(domain, "")
    Wombat.crawl do
      base_url domain
      path path_url
      name css: ".country-text h1"
      slug url.split("/").last
      full_url url
      cities "css=.left-content-holder article", :iterator do
        name  css: ".content-list-text h2 a"
        thumb({ xpath: "./figure/a/img/@src" })
        full_url({ xpath: "./div/h2/a/@href" })
        description css: ".list-info"
      end
    end
  end

  def fetch_and_save
    save(fetch)
  end

  def self.save(data)
    save_country(data)
    save_cities(data)
  end
  def self.save_country(data)
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
