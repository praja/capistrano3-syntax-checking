# encoding: utf-8

require 'capistrano'
require 'capistrano/ext/syntax_checking/erb'
require 'capistrano/ext/syntax_checking/javascript'
require 'capistrano/ext/syntax_checking/ruby'
require 'capistrano/ext/syntax_checking/haml'

unless Capistrano::Configuration.respond_to?(:instance)
  abort "Capistrano syntax checks extensions requires Capistrano 2"
end

Capistrano::Configuration.instance.load do
  namespace :check_syntax do

    desc "Check syntax of all files"
    task :default do
      ruby
      erb
      javascript
      haml
    end

    desc "Test syntax of all JavaScript files"
    task :javascript do
      paths = fetch(:syntax_check_paths, {})[:javascript]
      paths ||= %w(
        public/javascripts
      )
      Capistrano::SyntaxChecks.check_javascript(paths, :verbose => fetch(:syntax_check_verbose, true))
    end

    desc "Test syntax of all Ruby files"
    task :ruby do
      paths = fetch(:syntax_check_paths, {})[:ruby]
      paths ||= %w(
        app 
        lib
        config
        scripts
      )
      Capistrano::SyntaxChecks.check_ruby(paths, :verbose => fetch(:syntax_check_verbose, true))
    end

    desc "Test syntax of all ERB files"
    task :erb do
      paths = fetch(:syntax_check_paths, {})[:erb]
      paths ||= %w(
        app 
      )
      Capistrano::SyntaxChecks.check_erb(paths, :verbose => fetch(:syntax_check_verbose, true))
    end

    desc "Test syntax of all HAML files"
    task :haml do
      paths = fetch(:syntax_check_paths, {})[:haml]
      paths ||= %w(
        app
      )
      Capistrano::SyntaxChecks.check_haml(paths, :verbose => fetch(:syntax_check_verbose, true))
    end

  end
end
