# frozen_string_literal: true

if ENV['CI']
  require 'simplecov'

  SimpleCov.start do
    command_name "from_container_#{ENV.fetch('CIRCLE_NODE_INDEX', '')}"
    add_filter %w[bundle spec bin vendor tmp]
    coverage_dir ENV.fetch('COVERAGE_DIR', '.coverage')
  end
end

require 'bundler/setup'
require 'simple_images_downloader'
require 'byebug'
require 'faker'
require 'vcr'

Dir[File.dirname(__FILE__).concat('/support/**/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
