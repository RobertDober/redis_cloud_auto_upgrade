require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional do
  let(:rcau) { described_class.new.configure(**@heroku_params) }

  context '#potential_upgrade!' do
    context 'does not upgrade the plan' do
      before do
        allow(rcau).to receive(:needs_to_upgrade?).and_return false
        expect( HerokuAPI ).not_to receive(:upgrade_to_plan!)
      end
      it { rcau.potential_upgrade! }
    end # context 'does not upgrade the plan'
    context 'upgrades the plan' do
      before do
        allow(rcau).to receive(:needs_to_upgrade?).and_return true
        expect( HerokuAPI ).to \
          receive(:upgrade_to_plan!)
            .with(**@heroku_params)
      end
      it { rcau.potential_upgrade! }
    end # context 'does not upgrade the plan'
  end
end
