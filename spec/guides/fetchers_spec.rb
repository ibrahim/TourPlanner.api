
require 'rails_helper'
#{{{ Fetch Continent
RSpec.describe "Fetch Continent" do
  context "Fetch the continent page" do
    let(:continent){ 
      VCR.use_cassette('Africa/index') do
        Guides::Continent.new(name: "Africa", full_url: "https://www.arrivalguides.com/en/Travelguides/Africa").fetch 
      end
    }
    # it "should match the continent snapshot" do
    #   expect(continent).to match_snapshot("Africa")
    # end
    it "should match the continent schema" do
      expect(continent).to match_json_schema("guides/continent")
    end
    it "should fetch the name" do
      expect(continent["name"]).to eq("Africa")
    end
    it "should fetch the cities" do
      countries = continent["countries"].map{|country| country["name"]}
      expect(countries).to match_array(["Algeria", "Cape Verde", "Egypt", "Ethiopia", "Gambia", "Kenya", "Mauritius", "Morocco", "Namibia", "Réunion", "Senegal", "Seychelles", "South Africa", "Tanzania", "Tunisia"])
    end
    it "should fetch the country details" do
      continent["countries"].each do |country|
        expect(country["name"]).not_to be_empty
        expect(country["full_url"]).not_to be_empty
      end
    end
  end
end
#}}}
#{{{ Fetch Country
RSpec.describe "Fetch Country" do
  context "Fetch the country page" do
    let(:country){
      VCR.use_cassette('Africa/Egypt') do
        Guides::Country.new(name: "Egypt", full_url: "https://www.arrivalguides.com/en/Travelguides/Africa/Egypt").fetch
      end
    }
    # it "should match the country snapshot" do
    #   expect(country).to match_snapshot("Egypt")
    # end
    it "should match the country schema" do
      expect(country).to match_json_schema("guides/country")
    end
    it "should fetch the name" do
      expect(country["name"]).to eq("Egypt")
    end
    it "should fetch the full_url" do
      expect(country["full_url"]).to eq("https://www.arrivalguides.com/en/Travelguides/Africa/Egypt")
    end
    it "should fetch the slug" do
      expect(country["slug"]).to eq("Egypt")
    end
    it "should fetch the cities" do
      cities = country["cities"].map{|city| city["name"]}
      expect(cities).to match_array(["Cairo", "Hurghada, Luxor and Marsa Alam", "Sharm el-Sheikh"])
    end
    it "should fetch the destination details" do
      country["cities"].each do |city|
        expect(city["name"]).not_to be_empty
        expect(city["description"]).not_to be_empty
        expect(city["thumb"]).not_to be_empty
        expect(city["full_url"]).not_to be_empty
      end
    end
  end
end
#}}}
#{{{ Fetch City
RSpec.describe "Fetch City" do
  context "Fetch the city page" do
    let(:city){
      VCR.use_cassette('Africa/Egypt/Cairo') do
        Guides::City.new(name: "Cairo", full_url: "https://www.arrivalguides.com/en/Travelguides/Africa/Egypt/CAIRO").fetch
      end
    }
    # it "should match the city snapshot" do
    #   expect(city).to match_snapshot("Egypt")
    # end
    it "should match the city schema" do
      expect(city).to match_json_schema("guides/city")
    end
    it "should fetch the title" do
      expect(city["name"]).to eq("Cairo")
    end
    it "should fetch the country" do
      expect(city["country"]).to eq("Egypt")
    end
    it "should fetch the categories full_url" do
      expect(city["categories"].map{|cat| cat["full_url"]}.all?).to be_truthy 
    end
    it "should fetch the city facts" do
      expect(city["facts"].size).to eq(7)
      city["facts"].each do |fact|
        expect(fact["name"]).not_to be_empty
        expect(fact["info"]).not_to be_empty
      end
    end
    it "should fetch the city tags" do
      expect(city["tags"]).to match_array(["Historical destinations", "Vibrant Cities"])
    end
    it "should fetch the city last_updated date" do
      expect(city["last_updated"]).to eq("2018-12-17")
    end
  end
end
#}}}

categories = ["thecity","doandsee","eating","cafes","barsandnightlife","shopping","essentialinformation","weather"]
categories.each do |cat|
#{{{ Fetch Categories
RSpec.describe "Categories" do

  context "fetch" do
    let(:category){
      VCR.use_cassette("Africa/Egypt/Cairo/#{cat}") do
        Guides::Category.new(name: cat, full_url: "https://www.arrivalguides.com/en/Travelguides/Africa/Egypt/Cairo/#{cat}").fetch
      end
    }
    it "should fetch the category slug" do
      expect(category["slug"]).to eq(cat)
    end
    it "should fetch the category full_url" do
      expect(category["full_url"]).to eq("https://www.arrivalguides.com/en/Travelguides/Africa/Egypt/Cairo/#{cat}")
    end
    it "should fetch the category name" do
      expect(category["name"]).to_not be_empty
    end
    it "should fetch the category country" do
      expect(category["country"]).to eq("Egypt")
      expect(category["city"]).to eq("Cairo")
    end
    it "should fetch the category description" do
      expect(category["description"]).to_not be_empty unless cat =~ /weather|essentialinformation/
    end
    it "should fetch the category attractions" do
      expect(category["attractions"]).to_not be_empty unless cat =~ /weather|thecity/
    end
  end
end
#}}}
end
