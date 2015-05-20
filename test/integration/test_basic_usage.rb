require_relative '../helper'

class TestBasicUsage < Minitest::Test

  def test_no_arguments_given
    shell_output = ""
    expected = ""
    IO.popen('TEST=true ./mood_music', 'r+') do |pipe|
      expected = "[Help] Run as: ./mood_music manage\n"
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_bad_single_argument_given
    shell_output = ""
    expected = ""
    IO.popen('TEST=true ./mood_music bad_arg', 'r+') do |pipe|
      expected = "[Help] Run as: ./mood_music manage\n"
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_bad_multiple_argument_given
    shell_output = ""
    expected = ""
    IO.popen('TEST=true ./mood_music bad_arg1 bad_arg2', 'r+') do |pipe|
      expected = "[Help] Run as: ./mood_music manage\n"
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

  def test_manage_arg_given_then_exit
    shell_output = ""
    expected = ""
    IO.popen('TEST=true ./mood_music manage', 'r+') do |pipe|
      expected << main_menu
      pipe.puts "3"
      expected << "Peace Out!\n"
      pipe.close_write
      shell_output = pipe.read
    end
    assert_equal expected, shell_output
  end

end
