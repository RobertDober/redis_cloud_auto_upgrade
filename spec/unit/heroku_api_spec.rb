require 'spec_helper'
RSpec.describe HerokuAPI do
  context 'redis cloud plans' do
    context 'legal transitions' do
      it 'from 30 to 100' do
        expect(described_class.next_plan('rediscloud:30')).to eq('rediscloud:100')
      end
      it 'from 100 to 250' do
        expect(described_class.next_plan('rediscloud:100')).to eq('rediscloud:250')
      end
      it 'from 250 to 500' do
        expect(described_class.next_plan('rediscloud:250')).to eq('rediscloud:500')
      end
      it 'from 500 to 1_000' do
        expect(described_class.next_plan('rediscloud:500')).to eq('rediscloud:1_000')
      end
      it 'from 1_000 to 2_500' do
        expect(described_class.next_plan('rediscloud:1_000')).to eq('rediscloud:2_500')
      end
      it 'from 2_500 to 5_000' do
        expect(described_class.next_plan('rediscloud:2_500')).to eq('rediscloud:5_000')
      end
      it 'from 5_000 to 10_000' do
        expect(described_class.next_plan('rediscloud:5_000')).to eq('rediscloud:10_000')
      end
      it 'from 10_000 to 15_000' do
        expect(described_class.next_plan('rediscloud:10_000')).to eq('rediscloud:15_000')
      end
      it 'from 15_000 to 20_000' do
        expect(described_class.next_plan('rediscloud:15_000')).to eq('rediscloud:20_000')
      end
      it 'from 20_000 to 25_000' do
        expect(described_class.next_plan('rediscloud:20_000')).to eq('rediscloud:25_000')
      end
      it 'from 25_000 to 50_000' do
        expect(described_class.next_plan('rediscloud:25_000')).to eq('rediscloud:50_000')
      end
    end # context "legal transitions"

    context 'illegal transitions' do
      it 'raise an error if plan does not exist' do
        expect { described_class.next_plan('rediscloud:10') }.to \
          raise_error(ArgumentError, /the plan "rediscloud:10" does not exist or cannot be upgraded/)
      end
      it 'raise an error if plan cannot be upgraded' do
        expect { described_class.next_plan('rediscloud:50_000') }.to \
          raise_error(ArgumentError, /the plan "rediscloud:50_000" does not exist or cannot be upgraded/)
      end
    end # context 'illegal transitions'
  end # context "redis cloud plans"

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
          raise_error(ArgumentError, /the plan "rediscloud:10" does not exist/)
      end
    end # context 'illegal transitions'
  end # context 'redis cloud plan memory'
end
