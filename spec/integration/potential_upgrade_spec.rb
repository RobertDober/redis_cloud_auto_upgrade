require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional do
  let(:rcau) { described_class.new.configure(**@heroku_params) }

  context '#potential_upgrade!' do
    context 'does not upgrade the plan' do
      before do
        allow(rcau).to receive(:needs_to_upgrade?).and_return true
        allow(rcau).to receive(:do_upgrade!) { fail 'error' }
      end
      it { rcau.potential_upgrade! }
    end # context 'does not upgrade the plan'
  end
end
