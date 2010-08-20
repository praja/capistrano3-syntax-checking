# encoding: utf-8

module Capistrano
  module SyntaxChecks

    class << self

      # Check syntax in Ruby files. The +paths+ argument takes a single string 
      # or array of paths to check. Options may be:
      #
      # * +verbose+ - if true, enable verbose output to standard output. If false,
      #   only errors will be output.
      #
      def check_ruby(paths, options = {})
        verbose = options[:verbose]
        begin
          errors = false
          files = [paths].flatten.compact.map { |path|
            Dir.glob(File.join(path, "**", "*.rb"))
          }.flatten
          files.delete_if { |d| File.directory?(d) }
          if files.any?
            files.each_with_index do |file_name, index|
              IO.popen("ruby -c '#{file_name}' 2>&1", "r") do |input|
                input.each_line do |line|
                  unless line =~ /Syntax OK|\d: warning:/
                    print("\r")
                    puts(line)
                    errors = true
                  end
                end
              end
              if verbose
                $stdout.write("\r#{index + 1} files checked (ctrl-C to skip)")
                $stdout.flush
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
              puts("No files to check.")
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