require_relative 'test_helper'
require 'try_selector'

class TestTrySelector < Minitest::Test
  def setup
    @tmpdir = Dir.mktmpdir
  end

  def teardown
    FileUtils.remove_entry @tmpdir
  end

  def test_create_new_directory
    selector = TrySelector.new("", base_path: @tmpdir)
    selector.instance_variable_set(:@input_buffer, "test-dir")
    result = selector.send(:handle_create_new)

    date_prefix = Time.now.strftime("%Y-%m-%d")
    final_name = "#{date_prefix}-test-dir"
    expected_path = File.join(@tmpdir, final_name)

    assert_equal :mkdir, result[:type]
    assert_equal expected_path, result[:path]
  end

  def test_create_new_directory_with_git
    selector = TrySelector.new("", base_path: @tmpdir)
    selector.instance_variable_set(:@git_url_buffer, "https://github.com/tobi/try.git")
    result = selector.send(:handle_create_new)

    date_prefix = Time.now.strftime("%Y-%m-%d")
    final_name = "#{date_prefix}-try"
    expected_path = File.join(@tmpdir, final_name)

    assert_equal :mkdir_and_clone, result[:type]
    assert_equal expected_path, result[:path]
    assert_equal "https://github.com/tobi/try.git", result[:git_url]
  end

  def test_git_url_as_command_line_parameter
    selector = TrySelector.new("https://github.com/tobi/try.git", base_path: @tmpdir)
    
    assert_equal "https://github.com/tobi/try.git", selector.instance_variable_get(:@git_url_buffer)
    assert_equal "", selector.instance_variable_get(:@search_term)
  end
end