# simplecov\_html\_inline

This is a Ruby gem that contains `SimplecovHtmlInline::Formatter`, a [SimpleCov](https://github.com/simplecov-ruby/simplecov) formatter based on [simplecov-html](https://github.com/simplecov-ruby/simplecov-html) that uses inline/embedded assets (via data URIs).

This is useful for cases such as using continuous integration software that publishes artifacts to a private S3 bucket and lets you view artifacts by responding with a redirect to a signed S3 URL. With simplecov-html, the index.html file won't work because it uses relative URLs for assets, which do not have S3 signatures.

## Usage

```ruby
require 'simplecov'
require 'simplecov_html_inline'

SimpleCov.start do
  formatter SimplecovHtmlInline::Formatter
end
```
