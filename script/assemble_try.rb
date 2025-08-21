#!/usr/bin/env ruby

selector_class = File.read("lib/try_selector.rb")
main_script_content = File.read("main.rb")

# Extract the shebang from main.rb
shebang = main_script_content.slice!(/#!.*\n/)

# Remove the require_relative 'lib/try_selector' from the main_script
main_script_content = main_script_content.sub!(/require_relative 'lib\/try_selector'/, '')
main_script_content = main_script_content.sub!(/require '.*'$/, '')

requires = <<~EOF

require 'io/console'
require 'time'
require 'fileutils'
require 'tmpdir'
## Removed optparse; we'll manually parse CLI args
EOF

# Combine the class and the script
try_script = shebang + requires + "\n" + selector_class + "\n" + main_script_content

File.write("try.rb", try_script)
