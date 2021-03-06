class Guides::Continent
  include Mongoid::Document

  field :name, type: String
  field :full_url, type: String

  has_many :countries
  attr_accessor :result

  def fetch
    name = self.name
    continent_url = self.full_url
      VCR.use_cassette("Guides/en/Travelguides/#{name}") do
        @result = Wombat.crawl do
          base_url ENV["GUIDES_DOMAIN"]
          path "/en/Travelguides/#{name}"
          name css: ".continent-text h1"
          full_url continent_url
          countries "css=.main-container .tile-group article", :iterator do
            name  css: "a .tileOverlay .tileContentHolder h2"
            full_url({ xpath: "./a/@href" })
          end
      end
    end
    @result
  end

  def fetch_and_save_all
    fetch
    save_countries
  end

  def save_countries
    raise "Cannot save countries before continent is saved" if new_record?
    @result["countries"].each do |c|
      country = Guides::Country.new
      country.name = c["name"]
      country.full_url = c["full_url"]
      country.continent = self
      country.upsert
    end
  end
end
