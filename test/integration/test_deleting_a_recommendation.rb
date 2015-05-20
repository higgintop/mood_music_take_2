require_relative '../helper'

class TestDeletingARecommendation < Minitest::Test

    def test_deleting_a_recommendation_happy_path
    create_recommendation("Elephant", "Tame Impala", 1)
    create_recommendation("Tangerine", "Led Zeppelin", 1)
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "2" #list recommendations
      expected << category_sub_menu
      pipe.puts "1"
      expected << <<EOS
1. Elephant by Tame Impala
2. Tangerine by Led Zeppelin
EOS
      pipe.puts "1"
      expected << edit_delete_menu
      pipe.puts "2"
      expected << "Your song recommendation has been deleted.\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

end
