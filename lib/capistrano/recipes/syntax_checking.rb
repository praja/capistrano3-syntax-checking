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
    end

    desc "Test syntax of all JavaScript files"
    task :javascript do
      Capistrano::SyntaxChecks.check_javascript('public/javascripts', :verbose => true)
    end

    desc "Test syntax of all Ruby files"
    task :ruby do
      Capistrano::SyntaxChecks.check_ruby(%w(app lib), :verbose => true)
    end

    desc "Test syntax of all ERB files"
    task :erb do
      Capistrano::SyntaxChecks.check_erb('app', :verbose => true)
    end

  end
end
