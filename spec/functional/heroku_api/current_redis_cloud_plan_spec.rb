require 'vcr_helper'

RSpec.describe HerokuAPI, type: :functional do
  context 'normal access to (recorded) experimental platform' do
    it 'returns the rediscloud:30 plan' do
      VCR.use_cassette('heroku_api') do
        expect(HerokuAPI.current_redis_cloud_plan(**@heroku_params)).to \
          eq('rediscloud:30')
      end
    end
  end # context "normal access"
end
