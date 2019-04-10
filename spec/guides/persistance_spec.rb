
require 'rails_helper'
#{{{ Fetch Country
RSpec.describe "Persiting" do
    let(:country){
      VCR.use_cassette('Africa/Egypt') do
        CountryFetcher.new("Egypt","https://www.arrivalguides.com/en/Travelguides/Africa/Egypt").fetch
      end
    }
    let(:city){
      VCR.use_cassette('Africa/Egypt/Cairo') do
        CityFetcher.new("Cairo","https://www.arrivalguides.com/en/Travelguides/Africa/Egypt/CAIRO").fetch
      end
    }
    before(:all) do
      Guides::Country.delete_all
      Guides::City.delete_all
      Guides::Category.delete_all
      Guides::Attraction.delete_all
    end
    context "Country" do
      before do
        @country = Guides::Country.where(name: country["name"]).first
      end
      it "should save the country" do #{{{ 
        CountryFetcher.save_country(country)
        expect(Guides::Country.count).to eq(1)
        expect(Guides::Country.where({name: "Egypt"}).all.length).to eq(1)
      end
      #}}}
      it "should not allow duplicate country" do #{{{
        expect{ 
          # Guides::Country.create(name: country["title"]) 
          CountryFetcher.save_country(country)
        }.to raise_error(Mongo::Error::OperationFailure, /duplicate key error/)
      end #}}}
      it "should save country cities" do #{{{
        Guides::City.delete_all
        CountryFetcher.save_cities(country)
        expect(@country.cities.count).to eq(country["cities"].length)
      end #}}}
    end

    context "City" do
      before do
        @country = Guides::Country.where(name: city["country"]).first
        @city = @country.cities.where(name: city["name"]).first
      end
      it "should save city facts" do #{{{
        expect(city["facts"]).to_not be_empty
        facts_count = CityFetcher.save_facts(city)
        expect(facts_count).to eq(city["facts"].length)
      end #}}}
      it "should not allow duplicate city" do #{{{
        expect{ 
          Guides::City.create(name: city["name"], country: @country) 
        }.to raise_error(Mongo::Error::OperationFailure, /duplicate key error/)
      end #}}}
      it "should update city with addditional fields" do #{{{
        expect(@city.last_updated).to eq(nil)
        updated_city = CityFetcher.update_city(city)
        expect(updated_city.last_updated).to eq(city["last_updated"])
      end #}}}
        it "should save the city categories" do
          Guides::Category.delete_all
          categories_count = city["categories"].reject{|c| c["name"] =~ /Hotels/}.length
          categories = CityFetcher.save_categories(city)
          expect(categories).to have_exactly(categories_count).items
        end
    end

    categories = ["thecity","doandsee","eating","cafes","barsandnightlife","shopping","essentialinformation","weather"]
    categories.each do |cat|
      context "Category #{cat}" do
        let(:category){
          VCR.use_cassette("Africa/Egypt/Cairo/#{cat}") do
            CategoryFetcher.new(cat,"https://www.arrivalguides.com/en/Travelguides/Africa/Egypt/Cairo/#{cat}").fetch
          end
        }
        before do
          @country = Guides::Country.where(name: category["country"]).first
          @city = @country.cities.where(name: category["city"]).first
        end
        it "should save the attractions" do
          attractions = CategoryFetcher.save_attractions(category)
          expect(attractions.count).to eq(category["attractions"].length)
        end
      end
    end
end
#}}}
#{{{ Save City
RSpec.describe "City" do
  context "save" do
  end
end
#}}}

