# frozen_string_literal: true

require 'vcr_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional do
  context 'upgrade to next plan' do
    it 'from rediscloud:30' do
      VCR.use_cassette('heroku_api') do
      end
    end
  end # context 'upgrade to next plan'
end
