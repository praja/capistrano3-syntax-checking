# encoding: utf-8

begin
  require 'haml'
rescue LoadError
  # Ignore
end

module Capistrano
  module SyntaxChecks

    class << self

      # Check syntax in HAML files. The +paths+ argument takes a single string 
      # or array of paths to check. Options may be:
      #
      # * +verbose+ - if true, enable verbose output to standard output. If false,
      #   only errors will be output.
      #
      def check_haml(paths, options = {})
        if defined?(::Haml)          
          verbose = options[:verbose]
          begin
            errors = false
            file_names = [paths].flatten.compact.map { |path|
              Dir.glob(File.join(path, "**", "*.haml"))
            }.flatten
            file_names.delete_if { |d| File.directory?(d) }
            if file_names.any?
              file_names.each_with_index do |file_name, index|
                begin
                  ::Haml::Engine.new(File.read(file_name), :cache => false, :read_cache => false)
                rescue => e
                  puts "\r#{file_name}:#{e.line}: #{e.message}"
                  errors = true
                end
                if verbose
                  $stdout.write("\r#{index + 1} files checked (ctrl-C to skip)")
                  $stdout.flush
                end
              end
              if errors
                print("\r")
                abort("One or more syntax errors found. Fix and try again.")
              else
                puts ", no problems found."
              end
            else
              if verbose
                puts("No HAML files to check.")
              end
            end
          rescue Interrupt
            puts
            puts("Canceled, skipping.")
          end
        else
          $stderr << "HAML syntax checks disabled as HAML is not installed.\n"
        end
      end
      
    end

  end
end