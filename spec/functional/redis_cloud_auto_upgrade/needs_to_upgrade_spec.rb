# frozen_string_literal: true
require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional do
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
    context 'small plan' do
      let(:current_redis_cloud_plan) { 'rediscloud:30' }
      context 'is not reached' do
        let(:current_redis_mem_usage) { 14_999_999 }
        it { expect(rcau.needs_to_upgrade?).to be_falsey }
      end # context 'is not reached'

      context 'is reached' do
        let(:current_redis_mem_usage) { 15_000_000 }
        it { expect(rcau.needs_to_upgrade?).to be_truthy }
      end # context 'is reached'
    end # context 'small plan'

    context 'medium plan' do
      let(:current_redis_cloud_plan) { 'rediscloud:500' }

      context 'is not reached' do
        let(:current_redis_mem_usage) { 249_999_999 }
        it { expect(rcau.needs_to_upgrade?).to be_falsey }
      end # context 'is not reached'

      context 'is reached' do
        let(:current_redis_mem_usage) { 250_000_000 }
        it { expect(rcau.needs_to_upgrade?).to be_truthy }
      end # context 'is reached'
    end # context 'medium plan'

    context 'huge plan' do
      let(:current_redis_cloud_plan) { 'rediscloud:50000' }
      context 'is not reached' do
        let(:current_redis_mem_usage) { 24_999_999_999 }
        it { expect(rcau.needs_to_upgrade?).to be_falsey }
      end # context 'is not reached'

      context 'is reached' do
        let(:current_redis_mem_usage) { 25_000_000_000 }
        it { expect(rcau.needs_to_upgrade?).to be_truthy }
      end # context 'is reached'
    end # context 'huge plan'
  end # context 'default tresshold (50%)'

  context 'configured tresshold (80%)' do
    before do
      rcau.configure(treshhold: 0.8)
    end
    context 'big plan' do
      let(:current_redis_cloud_plan) { 'rediscloud:1000' }

      context 'is not reached' do
        let(:current_redis_mem_usage) { 799_999_999 }
        it { expect(rcau.needs_to_upgrade?).to be_falsey }
      end # context 'is not reached'

      context 'is reached' do
        let(:current_redis_mem_usage) { 800_000_000 }
        it { expect(rcau.needs_to_upgrade?).to be_truthy }
      end # context 'is reached'
    end # context 'big plan'
  end # context 'configured tresshold (80%)'
end
