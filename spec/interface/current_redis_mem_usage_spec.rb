require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  let_doubles :redis, :used_memory, :memory_usage

  it 'can calculate the current redis memory usage' do
    expect(Redis).to receive(:current).and_return redis
    expect(redis).to receive(:info).and_return('used_memory' => used_memory)
    expect(used_memory).to receive(:to_i).and_return memory_usage
    expect(described_class.current_redis_mem_usage).to eq memory_usage
  end
end
