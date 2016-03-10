require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  context 'illegal config' do
    let(:logger) { double }

    it 'raises an error' do
      expect { described_class.potential_upgrade!(logger: logger) {} }.to \
        raise_error described_class::IllegalConfiguration
    end
  end # context "illegal config"
end
