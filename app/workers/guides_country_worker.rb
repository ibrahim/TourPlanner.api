require 'sidekiq'

class GuidesCountryWorker
  include Sidekiq::Worker
  sidekiq_options expires_in: 24 * 60 * 60, retry: 10, queue: :guides

  def perform(country_id)
    country = Guides::Country.find(country_id)
    # return true unless country.name =~ /Egypt/
    country.fetch_and_save_all
    country.cities.each do |city|
      GuidesCityWorker.new.perform(city.id)
    end
  end
end
