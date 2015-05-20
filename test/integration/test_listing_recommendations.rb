require_relative '../helper'


class TestListingRecommendations < Minitest::Test

  def test_listing_of_no_recommendations
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu # this variable is defined in helper.rb
      pipe.puts "2" # list recommendations
      expected << category_sub_menu
      pipe.puts "1"
      expected << "No recommendations found.\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_listing_of_recommendations_happy_path
    create_recommendation("Elephant", "Tame Impala", "1")
    create_recommendation("Tangerine", "Led Zeppelin", "1")
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "2" # list recommendations
      expected << category_sub_menu
      pipe.puts "1"
      expected << "1. Elephant by Tame Impala\n"
      expected << "2. Tangerine by Led Zeppelin\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end
end
