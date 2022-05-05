# frozen_string_literal: true

require 'spec_helper'
RSpec.describe HerokuAPI do
  context 'redis cloud plan memory' do
    context 'legal plans' do
      it 'has 30M for plan rediscloud:30' do
        expect(described_class.available_memory('rediscloud:30')).to eq(30_000_000)
      end
      it 'has 100M for plan rediscloud:100' do
        expect(described_class.available_memory('rediscloud:100')).to eq(100_000_000)
      end
      it 'has 250M for plan rediscloud:250' do
        expect(described_class.available_memory('rediscloud:250')).to eq(250_000_000)
      end
      it 'has 500M for plan rediscloud:500' do
        expect(described_class.available_memory('rediscloud:500')).to eq(500_000_000)
      end
      it 'has 1_000M for plan rediscloud:1_000' do
        expect(described_class.available_memory('rediscloud:1000')).to eq(1_000_000_000)
      end
      it 'has 2_500M for plan rediscloud:2_500' do
        expect(described_class.available_memory('rediscloud:2500')).to eq(2_500_000_000)
      end
      it 'has 5_000M for plan rediscloud:5_000' do
        expect(described_class.available_memory('rediscloud:5000')).to eq(5_000_000_000)
      end
      it 'has 10_000M for plan rediscloud:1_0000' do
        expect(described_class.available_memory('rediscloud:10000')).to eq(10_000_000_000)
      end
      it 'has 15_000M for plan rediscloud:15000' do
        expect(described_class.available_memory('rediscloud:15000')).to eq(15_000_000_000)
      end
      it 'has 20_000M for plan rediscloud:20000' do
        expect(described_class.available_memory('rediscloud:20000')).to eq(20_000_000_000)
      end
      it 'has 25_000M for plan rediscloud:25000' do
        expect(described_class.available_memory('rediscloud:25000')).to eq(25_000_000_000)
      end
      it 'has 5_0000M for plan rediscloud:50000' do
        expect(described_class.available_memory('rediscloud:50000')).to eq(50_000_000_000)
      end
    end # context 'legal plans'
    context 'illegal plan' do
      it 'raises an error' do
        expect { described_class.available_memory('rediscloud:10') }.to \
          raise_error(ArgumentError, %r{the plan "rediscloud:10" does not exist})
      end
    end # context 'illegal transitions'
  end # context 'redis cloud plan memory'
end
