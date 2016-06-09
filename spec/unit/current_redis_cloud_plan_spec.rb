# frozen_string_literal: true
require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  let_doubles(:current_plan, :heroku_api_key, :heroku_app_name)

  let(:rcau) do
    described_class.new.configure(heroku_api_key: heroku_api_key, heroku_app_name: heroku_app_name)
  end

  it 'gets current plan' do
    # This delegation assuring setup is soooo common one day I will write a nice DSL for it, some day....
    expect(HerokuAPI).to \
      receive(:current_redis_cloud_plan)
      .with(heroku_api_key: heroku_api_key, heroku_app_name: heroku_app_name)
      .and_return(current_plan)

    expect(rcau.current_redis_cloud_plan).to eq(current_plan)
  end
end
