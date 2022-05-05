# frozen_string_literal: true

require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade, type: :functional do
  context 'illegal config' do
    let_double(:logger)

    it 'raises an error' do
      expect { described_class.potential_upgrade!(logger: logger) {} }.to \
        raise_error described_class::IllegalConfiguration
    end
  end # context "illegal config"

  context 'legal config creates a properly confifured RedisCloudAutoUpgrade instance' do
    let_double(:rcau)

    it 'and invokes #potential_upgrade! on it' do
      expect(described_class).to receive(:new).and_return rcau
      expect(rcau).to \
        receive(:configure)
        .with(@heroku_params.merge(on_upgrade: nil))
        .and_return(rcau)
      expect(rcau).to receive(:potential_upgrade!)

      described_class.potential_upgrade!(**@heroku_params)
    end
    it '(with the block) and invokes #potential_upgrade! on it' do
      block = -> {}
      # so that the block is identical to what is seen inside .described_class
      # def block.to_proc
      #   self
      # end
      expect(described_class).to receive(:new).and_return rcau
      expect(rcau).to \
        receive(:configure)
        .with(@heroku_params.merge(on_upgrade: block))
        .and_return(rcau)
      expect(rcau).to receive(:potential_upgrade!)

      described_class.potential_upgrade!(**@heroku_params, &block)
    end
  end # context 'legal config'
end
