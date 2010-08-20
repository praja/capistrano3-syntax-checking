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
          ignore_patterns = %w(
          )
          errors = false
          directories = %w(
            app
            bin
            lib
            config
          )
          files = directories.map { |d| Dir.glob(File.join(d, "**", "*.rb")) }.flatten
          files.delete_if { |d| File.directory?(d) }
          files.delete_if { |d| ignore_patterns.find { |p| d.index(p) } }
          files.each_with_index do |file_name, index|
            $stdout.write("\r#{index} files checked (ctrl-C to skip)")
            $stdout.flush
            IO.popen("ruby -c '#{file_name}' 2>&1", "r") do |input|
              input.each_line do |line|
                unless line =~ /Syntax OK|\d: warning:/
                  print("\r")
                  puts(line)
                  errors = true
                end
              end
            end
          end
          if errors
            print("\r")
            abort("One or more syntax errors found. Fix and try again.")
          else
            puts ", no problems found."
          end
        rescue Interrupt
          puts
          puts("Canceled, skipping.")
        end
      end
      
    end

  end
end