require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional  do
  let :rcau do
    described_class
      .new
      .configure(**@heroku_params)
  end

  before do
    expect_any_instance_of(RedisCloudAutoUpgrade).to \
      receive(:current_redis_mem_usage).and_return(current_redis_mem_usage)
    expect(HerokuAPI).to \
      receive(:current_redis_cloud_plan).and_return(current_redis_cloud_plan)
  end

  context 'default tresshold (50%)' do
    context 'is not reached' do
      let(:current_redis_mem_usage) { 14_999_999 }
      let(:current_redis_cloud_plan) { 'rediscloud:30' }
      it { expect(rcau.needs_to_upgrade?).to be_falsey }
    end # context 'is not reached'
  end # context 'default tresshold (50%)'
end
