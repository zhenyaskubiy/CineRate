require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'

# Add this for Sidekiq testing
require 'sidekiq/testing'

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  config.fixture_paths = [ Rails.root.join('spec/fixtures') ]
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.filter_rails_from_backtrace!

  # Include FactoryBot methods
  config.include FactoryBot::Syntax::Methods

  # Include file upload helpers
  config.include ActionDispatch::TestProcess::FixtureFile

  # Configure ActiveJob for testing
  config.before(:each) do
    ActiveJob::Base.queue_adapter = :test
    Sidekiq::Worker.clear_all
  end

  # For mailer tests
  config.include ActionMailer::TestHelper
end
