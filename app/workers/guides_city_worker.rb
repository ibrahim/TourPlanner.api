require 'sidekiq'

class GuidesCityWorker
  include Sidekiq::Worker
  sidekiq_options expires_in: 24 * 60 * 60, retry: 5, queue: :guides

  def perform(city_id)
    city = Guides::City.find(city_id)
    city.fetch_and_save_all
    city.categories.each do |category|
      GuidesCategoryWorker.new.perform(category.id)
    end
  end
end
