require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  it 'has a semantic version' do
    expect(described_class::VERSION).to match(/\A\d+\.\d+(:\.\d+)?/)
  end
end
