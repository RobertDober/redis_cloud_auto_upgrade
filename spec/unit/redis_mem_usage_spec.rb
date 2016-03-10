require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  let_doubles :redis, :used_memory, :memory_usage
  let(:rcau) { described_class.new }

  context '.current_redis_mem_usage' do
    it 'can calculate the memory usage of the current instance' do
      expect(Redis).to receive(:current).and_return redis
      expect(redis).to receive(:info).and_return('used_memory' => used_memory)
      expect(used_memory).to receive(:to_i).and_return memory_usage
      expect(rcau.current_redis_mem_usage).to eq memory_usage
    end

    it 'can calculate the memory usage of any Redis instance' do
      rcau.configure(redis_instance: redis)
      expect(redis).to receive(:info).and_return('used_memory' => used_memory)
      expect(used_memory).to receive(:to_i).and_return memory_usage
      expect(rcau.current_redis_mem_usage).to eq memory_usage
    end
  end
end
