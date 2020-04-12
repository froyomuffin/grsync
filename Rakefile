require "bundler/setup"

require_relative "lib/camera"

task :test do
  dir["test/*test.rb"].each do|test_file|
    ruby test_file
  end
end

IMPORT_DIR = 'import'
task :import do
  FileUtils.mkdir_p(IMPORT_DIR) unless File.directory?(IMPORT_DIR)

  puts "Fetching assets"

  assets = Camera.new.assets

  puts "Found #{assets.count} assets"

  assets.each_with_index do |asset, index|
    details = asset.details
    file_name = details[:file]

    puts "Downloading #{index + 1}/#{assets.count}"
    puts details

    data = asset.data[:data]
    relative_file_name = "#{IMPORT_DIR}/#{file_name}"

    File.write(relative_file_name, data)
  end
end

task :clean do
  puts "Cleaning import"
  FileUtils.rm_rf(Dir["#{IMPORT_DIR}/*"])
end