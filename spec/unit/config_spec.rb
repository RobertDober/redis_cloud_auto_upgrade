# frozen_string_literal: true

require 'spec_helper'
RSpec.describe RedisCloudAutoUpgrade::Configuration do
  let(:config) { described_class.new }

  context 'is invalid' do
    it 'if unconfigured' do
      expect(config).not_to be_valid
    end
    it 'if empty' do
      config.configure({})
      expect(config).not_to be_valid
    end
    it "if one required field's missing (heroku_api_key)" do
      config.configure(heroku_app_name: '...')
      expect(config).not_to be_valid
    end
    it "if one required field's missing (heroku_app_name)" do
      config.configure(heroku_api_key: '...')
      expect(config).not_to be_valid
    end
  end # context 'is invalid'

  context 'is valid' do
    let(:logger) { double }
    let(:on_upgrade) { double }

    before do
      config.configure(heroku_api_key: '...', heroku_app_name: '***')
    end

    it 'if both required values are provided' do
      expect(config).to be_valid
    end

    it 'and can access other fields' do
      config.configure(logger: logger)
      expect(config.logger).to eq logger
      expect(config.on_upgrade).to be_nil
      expect(config.redis_instance).to be_nil
    end

    it 'has a default value' do
      expect(config.treshhold).to be_within(0.0001).of(0.5)
    end

    it 'can set all fields' do
      config.configure(logger: logger)
      config.configure(treshhold: 1.0, on_upgrade: on_upgrade)
      expect(config.heroku_api_key).to eq '...'
      expect(config.heroku_app_name).to eq '***'
      expect(config.logger).to eq logger
      expect(config.on_upgrade).to eq on_upgrade
    end
  end # context 'is valid'

  context 'configure is chainable' do
    it { expect(config.configure).to be_kind_of(config.class) }
  end # context "config is chainable"

  context 'error handling' do
    it 'has errors if empty (after validation)' do
      expect(config.errors).to be_empty
      config.valid?
      expect(config.errors).not_to be_empty
    end

    context 'gives a human readable error message' do
      it 'if both required fields are missing' do
        config.valid?
        expect(config.errors_human_readable).to \
          eq(%(Missing required_fields: [:heroku_api_key, :heroku_app_name]))
      end
      it 'if one required field is missing' do
        config.configure(heroku_api_key: 'somekey')
        config.valid?
        expect(config.errors_human_readable).to \
          eq(%(Missing required_fields: [:heroku_app_name]))
      end
    end

    context 'if config is valid' do
      before do
        config.configure(heroku_api_key: '...', heroku_app_name: '***')
      end
      it 'does not have any human readable errors' do
        expect(config.errors_human_readable).to be_nil
      end
    end
  end # context 'error handling'

  context 'extracting values' do
    before do
      config.configure(heroku_api_key: '...', heroku_app_name: '***')
    end

    it 'with only' do
      expect(config.only(:heroku_api_key, :redis_instance)).to \
        eq(heroku_api_key: '...', redis_instance: nil)
    end
  end
end
