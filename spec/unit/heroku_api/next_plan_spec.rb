require 'spec_helper'
RSpec.describe HerokuAPI do
  context 'redis cloud plans' do
    context 'legal transitions' do
      it 'from 30 to 100' do
        expect(described_class.send(:next_plan, 'rediscloud:30')).to eq('rediscloud:100')
      end
      it 'from 100 to 250' do
        expect(described_class.send(:next_plan, 'rediscloud:100')).to eq('rediscloud:250')
      end
      it 'from 250 to 500' do
        expect(described_class.send(:next_plan, 'rediscloud:250')).to eq('rediscloud:500')
      end
      it 'from 500 to 1_000' do
        expect(described_class.send(:next_plan, 'rediscloud:500')).to eq('rediscloud:1_000')
      end
      it 'from 1_000 to 2_500' do
        expect(described_class.send(:next_plan, 'rediscloud:1_000')).to eq('rediscloud:2_500')
      end
      it 'from 2_500 to 5_000' do
        expect(described_class.send(:next_plan, 'rediscloud:2_500')).to eq('rediscloud:5_000')
      end
      it 'from 5_000 to 10_000' do
        expect(described_class.send(:next_plan, 'rediscloud:5_000')).to eq('rediscloud:10_000')
      end
      it 'from 10_000 to 15_000' do
        expect(described_class.send(:next_plan, 'rediscloud:10_000')).to eq('rediscloud:15_000')
      end
      it 'from 15_000 to 20_000' do
        expect(described_class.send(:next_plan, 'rediscloud:15_000')).to eq('rediscloud:20_000')
      end
      it 'from 20_000 to 25_000' do
        expect(described_class.send(:next_plan, 'rediscloud:20_000')).to eq('rediscloud:25_000')
      end
      it 'from 25_000 to 50_000' do
        expect(described_class.send(:next_plan, 'rediscloud:25_000')).to eq('rediscloud:50_000')
      end
    end # context "legal transitions"

    context 'illegal transitions' do
      it 'raise an error if plan does not exist' do
        expect { described_class.send(:next_plan, 'rediscloud:10') }.to \
          raise_error(ArgumentError, /the plan "rediscloud:10" does not exist or cannot be upgraded/)
      end
      it 'raise an error if plan cannot be upgraded' do
        expect { described_class.send(:next_plan, 'rediscloud:50_000') }.to \
          raise_error(ArgumentError, /the plan "rediscloud:50_000" does not exist or cannot be upgraded/)
      end
    end # context 'illegal transitions'
  end # context "redis cloud plans"
end
