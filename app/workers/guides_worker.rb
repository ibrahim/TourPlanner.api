require 'sidekiq'

class GuidesWorker
  include Sidekiq::Worker
  sidekiq_options expires_in: 24 * 60 * 60, retry: 5, queue: :guides

  def perform
    continents = ["Africa", "Asia", "Europe", "North_America", "Oceania", "South_America"]
    continents.each do |name|
      Guides::Continent.create(name: name, full_url: "/en/Travelguide/#{name}")
    end
    Guides::Continent.all.each do |continent|
      GuidesContinentWorker.new.perform(continent.id)
    end
  end
end
