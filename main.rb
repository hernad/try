#!/usr/bin/env ruby

require 'io/console'
require 'time'
require 'fileutils'
require 'tmpdir'

require_relative 'lib/try_selector'

# Main execution with OptionParser subcommands
if __FILE__ == $0

  # Global, token-aware printer for ANSI/UI output
  # Minimal semantic tokens:
  #  {text}        Reset to default foreground (keeps background)
  #  {dim_text}    Dim/gray foreground
  #  {h1}          Primary heading (bold + yellow)
  #  {h2}          Secondary heading (dim yellow)
  #  {highlight}   Emphasis (bold + yellow)
  #  {start_selected}/{end_selected}  Selection background on/off
  # Utility tokens (rare): {reset}, {reset_bg}, {clear_screen}, {clear_line}, {home}, {hide_cursor}, {show_cursor}
  def ui_print(text, io: STDERR)
    return if text.nil?
    $token_map ||= {
      # semantic foreground styles
      # '{text}' => "\e[39m",
      '{text}' => "\e[39m",
      '{dim_text}' => "\e[90m",
      '{h1}' => "\e[1;33m",
      '{h2}' => "\e[1;36m",
      '{highlight}' => "\e[1;33m",
      # resets/util
      '{reset}' => "\e[0m", '{reset_bg}' => "\e[49m",
      # screen/cursor
      '{clear_screen}' => "\e[2J", '{clear_line}' => "\e[2K", '{home}' => "\e[H",
      '{hide_cursor}' => "\e[?25l", '{show_cursor}' => "\e[?25h",
      # Selection background: faint
      '{start_selected}' => "\e[6m",
      '{end_selected}' => "\e[0m"
    }

    io.print(
      text.gsub(/\{.*?\}/) do |match|
        $token_map.fetch(match) { raise "Unknown token: #{match}" }
      end
    )
  end

  def print_global_help
    script_path = File.expand_path($0)
    ui_print <<~HELP
      {h1}try something!{text}

      Lightweight experiments for people with ADHD

      this tool is not meant to be used directly,
      but added to your ~/.zshrc or ~/.bashrc:

        {highlight}eval "$(#{script_path} init ~/src/tries)"{text}

      {h2}Usage:{text}
        init [--path PATH]  # Initialize shell function for aliasing
        cd [QUERY]          # Interactive selector; prints shell cd commands


      {h2}Defaults:{text}
        Default path: {dim_text}~/src/tries{text} (override with --path on commands)
        Current default: {dim_text}#{TrySelector::TRY_PATH}{text}
    HELP
  end

  # Global help: show for --help/-h anywhere
  if ARGV.include?("--help") || ARGV.include?("-h")
    print_global_help
    exit 0
  end

  # Helper to extract a "--name VALUE" or "--name=VALUE" option from args (last one wins)
  def extract_option_with_value!(args, opt_name)
    i = args.rindex { |a| a == opt_name || a.start_with?("#{opt_name}=") }
    return nil unless i
    arg = args.delete_at(i)
    if arg.include?('=')
      arg.split('=', 2)[1]
    else
      args.delete_at(i)
    end
  end

  command = ARGV.shift

  tries_path = extract_option_with_value!(ARGV, '--path') || TrySelector::TRY_PATH
  tries_path = File.expand_path(tries_path)

  case command
  when nil
    print_global_help
    exit 2
  when 'init'
    script_path = File.expand_path($0)

    if ARGV[0] && ARGV[0].start_with?('/')
      tries_path = File.expand_path(ARGV[0])
      ARGV.shift
    end

    path_arg = tries_path ? " --path \"#{tries_path}\"" : ""
    puts <<~SHELL
      try() {
        script_path='#{script_path}';
        cmd=$(/usr/bin/env ruby "$script_path" cd#{path_arg} "$@" 2>/dev/tty);
        [ $? -eq 0 ] && eval "$cmd" || echo "$cmd";
      }
    SHELL
    exit 0
  when 'cd'
    search_term = ARGV.join(' ')
    selector = TrySelector.new(search_term, base_path: tries_path)
    result = selector.run

    if result
      parts = []
      parts << "dir='#{result[:path]}'"
      case result[:type]
      when :mkdir
        parts << "mkdir -p \"$dir\""
        parts << "touch \"$dir\""
      when :mkdir_and_clone
        parts << "mkdir -p \"$dir\""
        parts << "cd \"$dir\""
        parts << "git clone '#{result[:git_url]}' ."
      end
      parts << "cd \"$dir\""
      puts parts.join(' && ')
    end
  else
    warn "Unknown command: #{command}"
    print_global_help
    exit 2
  end
end