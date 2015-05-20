require 'rubygems'
require 'bundler/setup'
require "minitest/reporters"
require "sqlite3"

Dir["./app/**/*.rb"].each {|f| require f}
Dir["./lib/**/*.rb"].each {|f| require f}
ENV["TEST"] = "true"

reporter_options = { color: true }
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(reporter_options)]

require 'minitest/autorun'

def main_menu
  "1. Add song recommendation\n2. List song recommendations\n3. Exit\n"
end

def category_sub_menu
  "What category would you like to see?\n1. happy\n2. sad\n3. mellow\n4. angry\n"
end

def edit_delete_menu
  "What would you like to do?\n1. edit\n2. delete\n3. exit\n"
end

# This is database for testing
# Prepares database for a test to be run
class Minitest::Test
  def setup
    Database.load_structure
    Database.execute("DELETE FROM recommendations;")
  end
end


def create_recommendation(song_title, artist, mood_category)
  Database.execute("INSERT INTO recommendations (song_title, artist, mood_category) VALUES (?,?,?)", song_title, artist, mood_category)
end




