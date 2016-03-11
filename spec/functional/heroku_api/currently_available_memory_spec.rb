require 'spec_helper'
RSpec.describe HerokuAPI, type: :functional do
  context '.currently_available_memory' do
    let_doubles(:current_memory, :current_plan)

    it 'is defined by the current plan and its associated memory' do
      expect(described_class).to \
        receive(:current_redis_cloud_plan).and_return(current_plan)
      expect(described_class).to \
        receive(:available_memory)
        .with(current_plan).and_return(current_memory)
      expect(described_class.currently_available_memory(**@heroku_params)).to \
        eq(current_memory)
    end
  end # context '.currently_available_memory'
end
