require "bundler/setup"

require "minitest/autorun"
require "webmock/minitest"
require "json"
require "byebug"

# Stolen from Rails lalala
class String
  def underscore
    word = self.dup
    word.gsub!(/::/, '/')
    word.gsub!(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
    word.gsub!(/([a-z\d])([A-Z])/,'\1_\2')
    word.tr!("-", "_")
    word.downcase!
    word
  end
end

module TestHelper
  LIB_LOCATION = "../lib/"

  def self.included(base)
    require_relative resolve_file(base.to_s)
  end

  private

  def self.resolve_file(test_name)
    "#{LIB_LOCATION}/#{test_name.underscore.gsub('_test', '')}.rb"
  end
end
