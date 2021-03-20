require 'simplecov'

SimpleCov.start do
  add_filter { |src_file| !src_file.project_filename.start_with?('/lib/') }

  # Using this odd technique so 'simplecov_html_inline' can be required after
  # SimpleCov starts coverage
  formatter_wrapper = Object.new
  def formatter_wrapper.new
    SimplecovHtmlInline::Formatter.new
  end
  formatter formatter_wrapper
end

require 'simplecov_html_inline'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
  config.filter_run_when_matching :focus
  config.disable_monkey_patching!
  config.warnings = true

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end
end
