Gem::Specification.new do |s|
  s.name = 'simplecov_html_inline'
  s.version = IO.read('VERSION').chomp
  s.authors = ['Toby Hsieh']
  s.homepage = 'https://github.com/tobyhs/simplecov_html_inline'
  s.summary = 'SimpleCov HTML formatter with inline assets'
  s.description = 'Formatter based on simplecov-html that uses inline/embedded assets'
  s.license = 'MIT'

  s.add_dependency 'simplecov', '~> 0.21'

  s.add_development_dependency 'rspec', '~> 3.10'
  s.add_development_dependency 'selenium-webdriver', '~> 3.142'

  s.files = `git ls-files`.split($/)
end
