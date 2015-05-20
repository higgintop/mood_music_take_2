#!/usr/bin/env ruby
# -*- ruby -*-

require 'rake/clean'
require 'rake/testtask'

task :default => :test

Rake::TestTask.new() do |config|
  config.pattern = "test/**/test_*.rb"
end

desc 'bootstrap database structure'
task :bootstrap_database do
  require_relative 'lib/database'
  Database.load_structure
end

desc 'importer'
task :import do
  require_relative 'app/models/recommendation'
  require_relative 'lib/Database'
  require 'csv'
  CSV.open('fixture.csv', 'r+').each do |row|
    rec = Recommendation.new
    rec.song_title = row[0]
    rec.artist = row[1]
    rec.mood_category = row[2].to_i
    rec.save
  end
end
