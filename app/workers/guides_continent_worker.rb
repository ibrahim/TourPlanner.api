
require 'sidekiq'

class GuidesContinentWorker
  include Sidekiq::Worker
  sidekiq_options expires_in: 24 * 60 * 60, retry: 5, queue: :guides

  def perform(continent_id)
    continent = Guides::Continent.find(continent_id)
    continent.fetch_and_save_all
    continent.countries.each do |country|
      GuidesCountryWorker.perform_async(country.id)
    end
  end
end
