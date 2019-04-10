require 'rails_helper'
require 'sidekiq/testing'
require 'sidekiq/api' # for the case of rails console

Sidekiq::Testing.fake!
RSpec.describe FetchCountryWorker, type: :worker do
  before do
    Sidekiq::Queue.new("guides").clear
    Sidekiq::RetrySet.new.clear
    Sidekiq::ScheduledSet.new.clear
  end
  it { is_expected.to be_processed_in :guides }
  it { is_expected.to be_retryable 5 }
  # it { is_expected.to be_unique }
  it { is_expected.to be_expired_in 24.hours }
  it 'enqueues FetchDesitination job' do
      VCR.use_cassette('Africa/Egypt') do
        FetchCountryWorker.new.perform("Egypt")
      end
      expect(FetchDestinationWorker).to have_enqueued_sidekiq_job("Cairo")
  end
end
