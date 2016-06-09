# frozen_string_literal: true
require 'vcr_helper'
require 'timecop'

RSpec.describe RedisCloudAutoUpgrade, type: :functional do
  let(:rcau) { described_class.new.configure(**@heroku_params) }

  context '#potential_upgrade!' do
    context 'does not upgrade the plan' do
      before do
        expect(rcau).to receive(:needs_to_upgrade?).and_return false
        expect(HerokuAPI).not_to receive(:upgrade_plan!)
      end
      it { rcau.potential_upgrade! }
      it 'does not execute the callback' do
        rcau.configure(on_upgrade: -> { raise('that should not happen') })
        rcau.potential_upgrade!
      end
      it 'logs an info message' do
        logger = double
        msg_rgx = %r{\ARedisCloudAutoUpgrade no upgrade needed fcv-experiments mem usage \d+MB}
        rcau.configure(logger: logger)
        expect(logger).to \
          receive(:info).with(msg_rgx)
        rcau.potential_upgrade!
      end
    end # context 'does not upgrade the plan'

    context 'upgrades the plan' do
      let :message do
        <<-EOM
upgraded RedisCloud plan for app: fcv-experiments
mem usage was approximately \\d+MB
old_plan was rediscloud:30
new_plan is rediscloud:100
          EOM
      end
      let(:message_rgx) { %r{\ARedisCloudAutoUpgrade #{message}} }

      before do
        allow(rcau).to receive(:current_redis_mem_usage).and_return 27_000_000
        allow(rcau).to receive(:currently_available_memory).and_return 30_000_000
        expect(rcau).to receive(:current_redis_cloud_plan).and_return 'rediscloud:30'
        expect(HerokuAPI).to \
          receive(:upgrade_plan!)
          .with(**@heroku_params)
          .and_return 'rediscloud:100'
      end
      it { rcau.potential_upgrade! }

      it 'executes the callback' do
        Timecop.freeze do
          passed_in_value = false
          rcau.configure(on_upgrade: -> (x) { passed_in_value = x })
          rcau.potential_upgrade!

          expect(passed_in_value.old_plan).to eq('rediscloud:30')
          expect(passed_in_value.new_plan).to eq('rediscloud:100')
          expect(passed_in_value.upgraded_at).to eq(Time.now)
          expect(passed_in_value.mem_usage).to eq(27_000_000)
          expect(passed_in_value.mem_usage_in_percent).to eq(90)
          expect(passed_in_value.treshhold_in_percent).to eq(50)
        end
      end
      it 'logs some useful info' do
        logger = double
        rcau.configure(logger: logger)

        expect(logger).to \
          receive(:info)
          .with(message_rgx)

        rcau.potential_upgrade!
      end
    end # context 'does not upgrade the plan'
  end
end
