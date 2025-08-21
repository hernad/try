require 'tmpdir'
require_relative '../lib/try_selector'

class TryTester
  def run
    Dir.mktmpdir do |tmpdir|
      puts "Running tests in #{tmpdir}"
      @base_path = tmpdir
      test_create_new_directory
      test_create_new_directory_with_git
    end
  end

  def test_create_new_directory
    puts "  - Test: Create new directory"
    selector = TrySelector.new("", base_path: @base_path)
    selector.instance_variable_set(:@input_buffer, "test-dir")
    result = selector.send(:handle_create_new)

    date_prefix = Time.now.strftime("%Y-%m-%d")
    final_name = "#{date_prefix}-test-dir"
    expected_path = File.join(@base_path, final_name)

    if result[:type] == :mkdir && result[:path] == expected_path
      puts "    - PASSED: Correct result returned"
    else
      puts "    - FAILED: Incorrect result returned"
    end
  end

  def test_create_new_directory_with_git
    puts "  - Test: Create new directory with git"
    selector = TrySelector.new("", base_path: @base_path)
    selector.instance_variable_set(:@git_url_buffer, "https://github.com/tobi/try.git")
    result = selector.send(:handle_create_new)

    date_prefix = Time.now.strftime("%Y-%m-%d")
    final_name = "#{date_prefix}-try"
    expected_path = File.join(@base_path, final_name)

    if result[:type] == :mkdir_and_clone && result[:path] == expected_path && result[:git_url] == "https://github.com/tobi/try.git"
      puts "    - PASSED: Correct result returned"
    else
      puts "    - FAILED: Incorrect result returned"
    end
  end
end
