require 'sidekiq'

class GuidesCategoryWorker
  include Sidekiq::Worker
  sidekiq_options expires_in: 24 * 60 * 60, retry: 5, queue: :guides

  def perform(category_id)
    category = Guides::Category.find(category_id)
    category.fetch_and_save_all
    # category.attractions.each do |attraction|
    #   GuidesAttractionWorker.perform_async(category.id)
    # end
  end
end
