# frozen_string_literal: true

require 'spec_helper'
require 'vcr'
VCR.configure do |config|
  config.cassette_library_dir = 'fixtures/vcr_cassettes'
  config.hook_into :webmock # or :fakeweb
end
