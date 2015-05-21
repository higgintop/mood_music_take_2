require_relative '../helper'

class TestEditingARecommendation < Minitest::Test

  def test_editing_a_recommendation_happy_path_a
    create_recommendation("Elephant", "Tame Impala", "happy")
    create_recommendation("Tangerine", "Led Zeppelin", "happy")
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "2"
      expected << category_sub_menu
      pipe.puts "1"
      expected << <<EOS
1. Elephant by Tame Impala
2. Tangerine by Led Zeppelin
EOS
      pipe.puts "1"
      expected << edit_delete_menu
      pipe.puts "1"
      expected << "Update song title? [y/n]\n"
      pipe.puts "y"
      expected << "Please enter new song title:\n"
      pipe.puts "Cause I'm a Man"
      expected << "Update song's artist? [y/n]\n"
      pipe.puts "n"
      expected << "Update mood category? [y/n]\n"
      pipe.puts "n"
      expected << "Your song recommendation has been saved.\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end



  def test_editing_a_recommendation_happy_path_b
    create_recommendation("Elephant", "Tame Impala", "happy")
    create_recommendation("Tangerine", "Led Zeppelin", "happy")

    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "2"
      expected << category_sub_menu
      pipe.puts "1"
      expected << <<EOS
1. Elephant by Tame Impala
2. Tangerine by Led Zeppelin
EOS
      pipe.puts "1"
      expected << edit_delete_menu
      pipe.puts "1"
      expected << "Update song title? [y/n]\n"
      pipe.puts "n"
      expected << "Update song's artist? [y/n]\n"
      pipe.puts "y"
      expected << "Please enter new artist:\n"
      pipe.puts "Lady Gaga"
      expected << "Update mood category? [y/n]\n"
      pipe.puts "n"
      expected << "Your song recommendation has been saved.\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_editing_a_recommendation_happy_path_c
    create_recommendation("Elephant", "Tame Impala", "happy")
    create_recommendation("Tangerine", "Led Zeppelin", "happy")

    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "2"
      expected << category_sub_menu
      pipe.puts "1"
      expected << <<EOS
1. Elephant by Tame Impala
2. Tangerine by Led Zeppelin
EOS
      pipe.puts "1"
      expected << edit_delete_menu
      pipe.puts "1"
      expected << "Update song title? [y/n]\n"
      pipe.puts "y"
      expected << "Please enter new song title:\n"
      pipe.puts "Bad Romance"
      expected << "Update song's artist? [y/n]\n"
      pipe.puts "y"
      expected << "Please enter new artist:\n"
      pipe.puts "Lady Gaga"
      expected << "Update mood category? [y/n]\n"
      pipe.puts "y"
      expected << "Please enter new mood category:\n1. happy\n2. sad\n3. mellow\n4. angry\n"
      pipe.puts "3"
      expected << "Your song recommendation has been saved.\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"

      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end
end
