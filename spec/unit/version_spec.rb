# frozen_string_literal: true
require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  it 'has a semantic version' do
    expect(described_class::VERSION).to match(%r{\A\d+\.\d+(:\.\d+)?})
  end
end
