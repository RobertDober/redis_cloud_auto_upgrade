# frozen_string_literal: true

require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade do
  let_doubles :redis, :used_memory, :memory_usage
  let(:rcau) { described_class.new }

  context '#current_redis_mem_usage' do
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

  context '#current_redis_mem_usage_megab' do
    before do
      expect(rcau).to receive(:current_redis_mem_usage).and_return current_redis_mem_usage
    end
    shared_examples_for 'current_redis_mem_usage_megab computation' do
      it { expect(rcau.send(:current_redis_mem_usage_megab)).to eq expected_megabytes }
    end
    context 'is computed from current_redis_mem_usage 119_999_999' do
      let(:current_redis_mem_usage) { 119_999_999 }
      let(:expected_megabytes) { 119 }
      it_behaves_like 'current_redis_mem_usage_megab computation'
    end
    context 'is computed from current_redis_mem_usage 201_000_000' do
      let(:current_redis_mem_usage) { 201_000_000 }
      let(:expected_megabytes) { 201 }
      it_behaves_like 'current_redis_mem_usage_megab computation'
    end
  end

  context '#current_redis_mem_usage_percent' do
    before do
      expect(rcau).to receive(:current_redis_mem_usage).and_return current_redis_mem_usage
      expect(rcau).to receive(:currently_available_memory).and_return currently_available_memory
    end
    shared_examples_for 'current_redis_mem_usage_percent computation' do
      it { expect(rcau.send(:current_redis_mem_usage_percent)).to eq expected_percentage }
    end
    context 'is computed from current_redis_mem_usage 201_000_000 and currently_available_memory 1_000_000_000' do
      let(:current_redis_mem_usage) { 201_000_000 }
      let(:currently_available_memory) { 1_000_000_000 }
      let(:expected_percentage) { 20 }
      it_behaves_like 'current_redis_mem_usage_percent computation'
    end

    context 'is computed from current_redis_mem_usage, danger Will Robinson' do
      let(:current_redis_mem_usage) { 21_000_000 }
      let(:currently_available_memory) { 5_000_000 }
      let(:expected_percentage) { 420 }
      it_behaves_like 'current_redis_mem_usage_percent computation'
    end
  end
end
