require 'spec_helper'
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
        rcau.configure(on_upgrade: -> { fail('that should not happen') })
        rcau.potential_upgrade!
      end
      it 'logs an info message' do
        logger = double
        rcau.configure(logger: logger)
        expect(logger).to receive(:info).with('no upgrade needed fcv-experiments mem usage 0MB')
        rcau.potential_upgrade!
      end
    end # context 'does not upgrade the plan'

    context 'upgrades the plan' do
      let :message do
        <<-EOM
upgraded RedisCloud plan for app: fcv-experiments
mem usage was approximately 0MB
old_plan was rediscloud:30
new_plan is rediscloud:100
          EOM
      end

      before do
        expect(rcau).to receive(:needs_to_upgrade?).and_return true
        expect(rcau).to receive(:current_redis_cloud_plan).and_return 'rediscloud:30'
        expect(HerokuAPI).to \
          receive(:upgrade_plan!)
          .with(**@heroku_params)
          .and_return 'rediscloud:100'
      end
      it { rcau.potential_upgrade! }
      it 'executes the callback' do
        callback_called = false
        rcau.configure(on_upgrade: -> (x) { x == rcau && callback_called = true })
        rcau.potential_upgrade!
        expect(callback_called).to be_truthy
      end
      it 'logs some useful info' do
        logger = double
        rcau.configure(logger: logger)

        expect(logger).to \
          receive(:info)
          .with(message)

        rcau.potential_upgrade!
      end
    end # context 'does not upgrade the plan'
  end
end
