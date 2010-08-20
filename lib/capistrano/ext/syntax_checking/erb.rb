# encoding: utf-8

module Capistrano
  module SyntaxChecks

    class << self
      
      # Check ERB syntax. The +paths+ argument takes a single string or array of paths
      # to check. Options may be:
      #
      # * +verbose+ - if true, enable verbose output to standard output. If false,
      #   only errors will be output.
      #
      def check_erb(paths, options = {})
        verbose = options[:verbose]
        begin
          require "erb"
          errors = false
          file_names = [paths].flatten.compact.map { |path|
            Dir.glob(File.join(path, "**", "*.{erb,rhtml}"))
          }.flatten
          file_names.each_with_index do |file_name, index|
            if verbose
              $stdout.write("\r#{index} files checked (ctrl-C to skip)")
              $stdout.flush
            end
            old_stderr = $stderr
            begin
              $stderr = File.open("/dev/null", 'w')
              template = ERB.new(File.read(file_name), nil, "-")
              begin
                template.result
              rescue SyntaxError => e
                $stderr << "\rSyntax error in ERB template #{file_name}: #{e}\n"
                $stderr.flush
                errors = true
              rescue Exception
                # Ignore
              end
            ensure
              $stderr = old_stderr
            end
          end
          if errors
            if verbose
              print "\r"
            end
            abort("One or more syntax errors found. Fix and try again.")
          else
            if verbose
              puts ", no problems found."
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