require 'base64'

require 'simplecov'
require 'simplecov-html'

class SimplecovHtmlInline
  # A SimpleCov formatter based on {SimpleCov::Formatter::HTMLFormatter} that
  # uses inline/embedded assets
  class Formatter < SimpleCov::Formatter::HTMLFormatter
    # Mapping from file extension to media type
    MEDIA_TYPE_MAPPING = {
      '.css' => 'text/css',
      '.gif' => 'image/gif',
      '.js' => 'text/javascript',
      '.png' => 'image/png',
    }.freeze

    # Directory where simplecov-html assets live
    PUBLIC_DIR = Gem.find_latest_files(
      'simplecov-html.rb'
    ).first.then do |simplecov_html_rb_path|
      dir = File.join(File.dirname(simplecov_html_rb_path), '..', 'public')
      File.absolute_path(dir).freeze
    end

    # Creates an HTML coverage report with inline assets
    #
    # @param result [SimpleCov::Result] the SimpleCov result to format
    def format(result)
      # Same as SimpleCov::Formatter::HTMLFormatter#format except we omit the
      # copying of asset files
      File.open(File.join(output_path, 'index.html'), 'wb') do |file|
        file.puts template('layout').result(binding)
      end
      puts output_message(result)
    end

    private

    # Constructs a data URI for an asset with the given name.
    #
    # @note
    #   This overrides {SimpleCov::Formatter::HTMLFormatter#assets_path} (which
    #   returns a relative URL)
    #
    # @param name [String]
    #   name of file (relative to simplecov-html's public directory) to return
    #   a data URI for
    # @return [String]
    #   data URI for the asset, or an empty string if an asset with the given
    #   name does not exist
    def assets_path(name)
      file_path = File.join(PUBLIC_DIR, name)
      return '' unless File.exist?(file_path)

      media_type = MEDIA_TYPE_MAPPING.fetch(File.extname(name))
      contents = IO.read(file_path)

      if media_type == 'text/css'
        contents.gsub!(/url\(['"]?(.+?)['"]?\)/) { "url(#{assets_path($1)})" }
      end

      "data:#{media_type};base64,#{Base64.strict_encode64(contents)}"
    end
  end
end
