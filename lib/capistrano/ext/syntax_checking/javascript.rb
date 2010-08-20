# encoding: utf-8

module Capistrano
  module SyntaxChecks

    class << self

      # Check syntax in JavaScript files. The +paths+ argument takes a single 
      # string or array of paths to check. Options may be:
      #
      # * +verbose+ - if true, enable verbose output to standard output. If false,
      #   only errors will be output.
      #
      def check_javascript(paths, options = {})
        verbose = options[:verbose]
        begin
          errors = false
          file_names = [paths].flatten.compact.map { |path|
            Dir.glob(File.join(path, "**", "*.js"))
          }.flatten
          if file_names.any?
            jar_path = File.join(File.dirname(__FILE__), "../../../closure/compiler.jar")
            if verbose
              print("Checking #{file_names.length} files with Closure")
            end
            command_line = "java -jar #{jar_path} " <<
              "--compilation_level WHITESPACE_ONLY " <<
              "--process_closure_primitives false " <<
              "--warning_level QUIET " <<
              "--js_output_file /dev/null " <<
              "--third_party "
            command_line << file_names.map { |fn| "--js '#{fn}' 2>&1"}.join(' ')
            IO.popen(command_line, 'r') do |input|
              input.each_line do |line|
                unless line =~ /^\d+ error(s)/
                  print("\r")
                  puts(line)
                end
                errors = true
              end
            end
            if errors
              if verbose
                print("\r")
              end
              abort("One or more syntax errors found. Fix and try again.")
            else
              if verbose
                puts ", no problems found."
              end
            end
          else
            if verbose
              puts("No JavaScript files to check.")
            end
          end
        rescue Interrupt
          if verbose
            puts
          end
          puts("Canceled, skipping.")
        end

      end

    end

  end
end