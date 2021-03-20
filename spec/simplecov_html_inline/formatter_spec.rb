require 'selenium-webdriver'

require 'simplecov_html_inline/formatter'

RSpec.describe SimplecovHtmlInline::Formatter do
  let(:coverage_path) { 'spec/tmp/coverage' }
  subject(:formatter) { described_class.new }

  describe '#format' do
    let(:original_result) do
      {
        'spec/fixtures/test1.rb' => { 'lines' => [1, 1, 1, nil, nil] },
        'spec/fixtures/test2.rb' => {
          'lines' => [1, 1, 1, 1, nil, 0, nil, nil, nil],
        },
      }.transform_keys(&File.method(:absolute_path))
    end

    let(:result) do
      SimpleCov::Result.new(
        original_result,
        command_name: 'TestTest',
        created_at: Time.at(1615761100)
      )
    end

    let(:web_driver) { Selenium::WebDriver.for(:chrome) }

    before do
      FileUtils.rm_rf(coverage_path)
      FileUtils.mkdir_p(coverage_path)
      allow(SimpleCov).to receive(:coverage_path).and_return(coverage_path)
      # spec_helper.rb adds a filter that only includes lib/ files, so we need
      # to stub this here so spec/fixtures/ files are included
      allow(SimpleCov).to receive(:filters).and_return([])
    end

    after do
      web_driver.quit
    end

    it 'creates an HTML coverage report with inline assets' do
      formatter.format(result)

      index_path = File.join(Dir.pwd, coverage_path, 'index.html')
      web_driver.get("file://#{index_path}")

      aggregate_failures do
        # Check that the JavaScript file is inline
        script_element = web_driver.find_element(:tag_name, 'script')
        expect(script_element.attribute('src')).to start_with(
          'data:text/javascript;base64,'
        )

        # Check that the CSS file is inline
        css_element = web_driver.find_element(css: 'link[rel="stylesheet"]')
        css_data_uri = css_element.attribute('href')
        expect(css_data_uri).to start_with('data:text/css;base64,')

        # Check that the image URLs in the CSS file are data URIs
        css_content = css_data_uri.split(',', 2)[1]
        css_content = Base64.strict_decode64(css_content)
        css_content.scan(/url\((.+?)\)/) do |match|
          expect(match[0]).to match(%r{\Adata:image/[a-z]+;base64,})
        end

        # Check that clicking a file shows its source
        file_name = 'spec/fixtures/test1.rb'
        file_a_element = web_driver.find_element(css: "a[title='#{file_name}']")
        file_a_element.click

        file_id = file_a_element.attribute('href').split('#').last
        source_table = web_driver.find_element(id: file_id)
        expect(source_table).to be_displayed

        web_driver.find_element(id: 'cboxClose').click
        Selenium::WebDriver::Wait.new(
          message: 'Source table for file did not close',
          timeout: 1,
        ).until do
          !source_table.displayed?
        end
      end
    end
  end
end
