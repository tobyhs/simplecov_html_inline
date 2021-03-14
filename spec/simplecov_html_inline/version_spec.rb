require 'simplecov_html_inline/version'

RSpec.describe 'SimplecovHtmlInline::VERSION' do
  it 'resembles a version string' do
    expect(SimplecovHtmlInline::VERSION).to match(/\A\d+\.\d+\.\d+\z/)
  end
end
