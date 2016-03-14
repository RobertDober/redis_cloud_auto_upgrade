require 'vcr_helper'

RSpec.describe HerokuAPI do
  context 'upgrading the plan', type: :functional do
    it 'will upgrade the plan from rediscloud:30 to rediscloud:100' do
      # N.B. When the cassette is not in place the upgrade will take place for real
      # and we need to downgrade **manually**!!!!
      VCR.use_cassette('heroku_api_upgrade') do
        new_plan = HerokuAPI.upgrade_plan!(**@heroku_params)
        expect(HerokuAPI.current_redis_cloud_plan(**@heroku_params)).to \
          eq('rediscloud:100')
        expect(new_plan).to eq('rediscloud:100')
      end
    end
  end # context 'upgrading the plan from rediscloud:30 to rediscloud:100'
end
