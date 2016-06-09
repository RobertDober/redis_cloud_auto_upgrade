# frozen_string_literal: true
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
      it 'from 500 to 1000' do
        expect(described_class.send(:next_plan, 'rediscloud:500')).to eq('rediscloud:1000')
      end
      it 'from 1000 to 2500' do
        expect(described_class.send(:next_plan, 'rediscloud:1000')).to eq('rediscloud:2500')
      end
      it 'from 2500 to 5000' do
        expect(described_class.send(:next_plan, 'rediscloud:2500')).to eq('rediscloud:5000')
      end
      it 'from 5000 to 10000' do
        expect(described_class.send(:next_plan, 'rediscloud:5000')).to eq('rediscloud:10000')
      end
      it 'from 10000 to 15000' do
        expect(described_class.send(:next_plan, 'rediscloud:10000')).to eq('rediscloud:15000')
      end
      it 'from 15000 to 20000' do
        expect(described_class.send(:next_plan, 'rediscloud:15000')).to eq('rediscloud:20000')
      end
      it 'from 20000 to 25000' do
        expect(described_class.send(:next_plan, 'rediscloud:20000')).to eq('rediscloud:25000')
      end
      it 'from 25000 to 50000' do
        expect(described_class.send(:next_plan, 'rediscloud:25000')).to eq('rediscloud:50000')
      end
    end # context "legal transitions"

    context 'illegal transitions' do
      it 'raise an error if plan does not exist' do
        expect { described_class.send(:next_plan, 'rediscloud:10') }.to \
          raise_error(ArgumentError, %r{the plan "rediscloud:10" does not exist or cannot be upgraded})
      end
      it 'raise an error if plan cannot be upgraded' do
        expect { described_class.send(:next_plan, 'rediscloud:50000') }.to \
          raise_error(ArgumentError, %r{the plan "rediscloud:50000" does not exist or cannot be upgraded})
      end
    end # context 'illegal transitions'
  end # context "redis cloud plans"
end
