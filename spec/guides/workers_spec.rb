require 'rails_helper'
require 'sidekiq/testing'
require 'sidekiq/api' # for the case of rails console

# Sidekiq::Testing.fake!
RSpec.describe "Guides", type: :worker do
  before(:all) do
    Sidekiq::Queue.new("guides").clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
    DatabaseCleaner.clean
    Guides::Continent.delete_all
    Guides::Country.delete_all
    Guides::City.delete_all
    Guides::Category.delete_all
    Guides::Attraction.delete_all
  end
  describe GuidesContinentWorker do
    before(:all) do
      @continent = Guides::Continent.create!(name: "Africa", full_url: "https://www.arrivalguides.com/en/Travelguides/Africa")
    end
    it { is_expected.to be_processed_in :guides }
    it { is_expected.to be_retryable 5 }
    # it { is_expected.to be_unique }
    it { is_expected.to be_expired_in 24.hours }
    it 'enqueues GuidesCountryWorker job' do
      expect(GuidesCountryWorker.jobs.length).to eq(0)
      VCR.use_cassette('Africa/index') do
        GuidesContinentWorker.new.perform(@continent.id)
      end
      expect(GuidesCountryWorker.jobs.length).to eq(@continent.countries.length)
    end
    describe GuidesCountryWorker do
      before(:all) do
        Sidekiq::Worker.clear_all
        @country = @continent.countries.where({name: "Egypt"}).first
      end
      it "expect country's continent is set properly" do
        expect(@country.continent).to eq(@continent)
        expect(@country.new_record?).to be_falsy
      end
      it 'enqueues GuidesCityWorker job' do
        expect(GuidesCityWorker.jobs.length).to eq(0)
        VCR.use_cassette('Africa/Egypt') do
          GuidesCountryWorker.new.perform(@country.id)
        end
        expect(GuidesCityWorker.jobs.length).to eq(@country.cities.length)
      end
      describe GuidesCityWorker do
        before(:all) do
          Sidekiq::Worker.clear_all
          @city = @country.cities.where({name: "Cairo"}).first
        end
        it 'enqueues GuidesCategoryWorker job' do
          expect(GuidesCityWorker.jobs.length).to eq(0)
          VCR.use_cassette('Africa/Egypt/Cairo') do
            GuidesCityWorker.new.perform(@city.id)
          end
          expect(GuidesCategoryWorker.jobs.length).to eq(@city.categories.length)
        end
      end
    end
  end
end
