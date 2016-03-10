require 'spec_helper'
require 'vcr'

RSpec.describe HerokuAPI, :wip do
  let :heroku_api_key do
    ENV['HEROKU_API_KEY'] || fail('need to set the env variable HEROKU_API_KEY for this test')
  end
  let(:heroku_app_name) { 'fcv-experiments' }

  context 'normal access to (recorded) experimental platform' do
    it 'returns the rediscloud:30 plan' do
      VCR.use_cassette('heroku_api') do
        expect(HerokuAPI.current_redis_cloud_plan(
                 heroku_api_key: heroku_api_key,
                 heroku_app_name: heroku_app_name
        )).to eq('rediscloud:30')
      end
    end
  end # context "normal access"
end
