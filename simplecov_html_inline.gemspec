Gem::Specification.new do |s|
  s.name = 'simplecov_html_inline'
  s.version = '0.0.1'
  s.authors = ['Toby Hsieh']
  s.homepage = 'https://github.com/tobyhs/simplecov_html_inline'
  s.summary = 'SimpleCov HTML formatter with inline assets'
  s.description = 'Formatter based on simplecov-html that uses inline/embedded assets'
  s.license = 'MIT'

  s.add_dependency 'simplecov-html', '~> 0.12'

  s.add_development_dependency 'rspec', '~> 3.10'

  s.files = `git ls-files`.split($/)
end
