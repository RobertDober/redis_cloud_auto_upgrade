# frozen_string_literal: true
require 'spec_helper'
RSpec.describe HerokuAPI, type: :functional do
  context 'next plan to uprade to' do
    let_doubles(:current_plan, :next_plan)

    it 'depends on the current plan only' do
      expect(described_class).to \
        receive(:current_redis_cloud_plan)
        .with(**@heroku_params).and_return(current_plan)

      expect(described_class).to \
        receive(:next_plan)
        .with(current_plan).and_return next_plan

      expect(described_class.next_plan_to_upgrade_to(**@heroku_params)).to eq next_plan
    end
  end # context 'next plan to uprade to'
end
