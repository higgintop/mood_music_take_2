require_relative '../helper'

class TestAddingARecommendation < Minitest::Test


  def test_add_song_happy_path
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
    pipe.puts "1"
    expected << "What is the song's title?\n"
    pipe.puts "Elephant"
    expected << "Who is the artist of the song?\n"
    pipe.puts "Tame Impala"
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts "1"
    expected << "Your recommendation was successfully saved to the database\n"
    expected << main_menu
    pipe.puts "3"
    expected << "Peace Out!\n"
    pipe.close_write
    shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end


  def test_add_song_empty_song_title
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "1"
      expected << "What is the song's title?\n"
      pipe.puts ""
      expected << "What is the song's title?\n"
      pipe.puts "Elephant"
      expected << "Who is the artist of the song?\n"
      pipe.puts "Tame Impala"
      expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
      pipe.puts "1"
      expected << "Your recommendation was successfully saved to the database\n"
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_add_song_empty_artist
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected = <<EOS
1. Add song recommendation
2. List song recommendations
3. Exit
EOS
    pipe.puts "1"
    expected << "What is the song's title?\n"
    pipe.puts "Elephant"
    expected << "Who is the artist of the song?\n"
    pipe.puts ""
    expected << "Who is the artist of the song?\n"
    pipe.puts "Tame Impala"
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts "1"
    expected << "Your recommendation was successfully saved to the database\n"
    expected << main_menu
    pipe.puts "3"
    expected << "Peace Out!\n"

    pipe.close_write
    shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_add_song_invalid_mood_category
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected = <<EOS
1. Add song recommendation
2. List song recommendations
3. Exit
EOS
    pipe.puts "1"
    expected << "What is the song's title?\n"
    pipe.puts "Elephant"
    expected << "Who is the artist of the song?\n"
    pipe.puts "Tame Impala"
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts "5"
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts "1"
    expected << "Your recommendation was successfully saved to the database\n"
    expected << main_menu
    pipe.puts "3"
    expected << "Peace Out!\n"

    pipe.close_write
    shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_add_song_empty_mood_category
    shell_output = ""
    expected = ""
    IO.popen('./mood_music manage', 'r+') do |pipe|
      expected = <<EOS
1. Add song recommendation
2. List song recommendations
3. Exit
EOS
    pipe.puts "1"
    expected << "What is the song's title?\n"
    pipe.puts "Elephant"
    expected << "Who is the artist of the song?\n"
    pipe.puts "Tame Impala"
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts ""
    expected << <<EOS
How would you classify the feel of this song?
1. happy
2. sad
3. mellow
4. angry
EOS
    pipe.puts "1"
    expected << "Your recommendation was successfully saved to the database\n"
    expected << main_menu
    pipe.puts "3"
    expected << "Peace Out!\n"

    pipe.close_write
    shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end



end

