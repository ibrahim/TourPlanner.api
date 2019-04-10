
require 'rails_helper'
#{{{ Fetch Country
RSpec.describe "Persiting" do
    before(:all) do
      DatabaseCleaner.clean
      Guides::Continent.delete_all
      Guides::Country.delete_all
      Guides::City.delete_all
      Guides::Category.delete_all
      Guides::Attraction.delete_all
      @continent = VCR.use_cassette('Africa/index') do
        Guides::Continent.new(
          name: "Africa", 
          full_url: "https://www.arrivalguides.com/en/Travelguides/Africa"
        ).tap do |c|
            c.fetch
        end
      end
    end
    describe "Continent" do
      it "should save the continent" do
        expect(@continent.result["name"]).to eq("Africa")
        expect(Guides::Continent.count).to eq(0)
        @continent.save!
        expect(Guides::Continent.count).to eq(1)
        expect(@continent.name).not_to be_empty
        expect(@continent.full_url).not_to be_empty
      end

      it "should save countries" do
        expect(@continent.result["countries"]).to_not be_empty
        expect(@continent.countries).to have_exactly(0).items
        @continent.save_countries
        expect(@continent.countries).to have_exactly(@continent.result["countries"].length).items
      end

      describe "Country" do
        before(:all) do
          @country = VCR.use_cassette('Africa/Egypt') do
            @continent.countries.where({name: "Egypt"}).first.tap do |c|
                c.fetch
            end
          end
        end
        it "should save country" do
          expect(@country.new_record?).to be_falsy
        end
        it "should not allow duplicate country" do #{{{
          expect{ 
            _c = Guides::Country.create!(name: @country.name, continent: @continent) 
          }.to raise_error(Mongo::Error::OperationFailure, /duplicate key error/)
        end #}}}
        it "should save country cities" do #{{{
          cities = @country.save_cities
          expect(cities.count).to eq(@country.result["cities"].length)
        end #}}}

        describe "City" do
          before(:all) do
            @city = VCR.use_cassette('Africa/Egypt/Cairo') do
              @country.cities.where({name: "Cairo"}).first.tap do |c|
                c.fetch
              end
            end
          end
          it "should update city" do #{{{ 
            expect(@city.last_updated_changed?).to be_truthy
            @city.save!
            expect(@city.last_updated_changed?).to be_falsy
          end #}}}
          it "should not allow duplicate city" do #{{{
            expect{ 
              Guides::City.create(name: @city.name, country: @country) 
            }.to raise_error(Mongo::Error::OperationFailure, /duplicate key error/)
          end #}}}
          it "should save city facts" do #{{{
            expect(@city.result["facts"]).to_not be_empty
            @city.save_facts
            expect(@city.facts.count).to eq(@city.result["facts"].length)
          end #}}}
            it "should save the city categories" do
              expect(@city.categories).to have_exactly(0).items
              @city.save_categories
              expect(@city.categories).to have_exactly(@city.result["categories"].length).items
            end

          categories = ["thecity","doandsee","eating","cafes","barsandnightlife","shopping","essentialinformation"]
          categories.each do |cat|
            describe "Category #{cat}" do
              before do
                @category = VCR.use_cassette("Africa/Egypt/Cairo/#{cat}") do
                  @city.categories.where({slug: cat}).first.tap do |c|
                    c.fetch
                  end
                end
              end
              it "should save the attractions" do
                @category.save_attractions
                expect(@category.attractions.count).to eq(@category.result["attractions"].length)
              end
            end
          end
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

