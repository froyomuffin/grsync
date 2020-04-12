require "bundler/setup"
require "byebug"

Dir["app/*.rb"].each { |file| require_relative file }

byebug

puts
