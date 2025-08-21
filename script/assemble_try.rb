#!/usr/bin/env ruby

selector_class = File.read("lib/try_selector.rb")
main_script_content = File.read("main.rb")

# Extract the shebang from main.rb
shebang = main_script_content.slice!(/#!.*\n/)

# Remove the require_relative 'lib/try_selector' from the main_script
main_script_content.sub!(/require_relative 'lib\/try_selector'/, '')

# Combine the class and the script
try_script = shebang + "\n" + selector_class + "\n" + main_script_content

File.write("try.rb", try_script)
