require 'rubygems'

unless defined?(TESTS_ARE_LOADED)
  # silence_warnings { BCrypt::Engine::DEFAULT_COST = BCrypt::Engine::MIN_COST }
  require 'rspec/rails'
  require 'rspec/expectations'
  require 'rspec/collection_matchers'
  require 'webmock/rspec'
  require 'shoulda/matchers'
end


RSpec.configure do |config|

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
