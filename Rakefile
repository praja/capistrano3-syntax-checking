# encoding: utf-8

require 'rubygems'
require 'rake'
require 'rake/rdoctask'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "capistrano-syntax-checking"
    gem.summary = gem.description = %Q{Capistrano extension that adds syntax checks for Ruby, ERB and JavaScript files.}
    gem.email = "alex@bengler.no"
    gem.homepage = "http://github.com/alexstaubo/capistrano-syntax-checking"
    gem.authors = ["Alexander Staubo"]
    gem.has_rdoc = true
    gem.require_paths = ["lib"]
    gem.files = FileList[%W(
      README.markdown
      VERSION
      LICENSE*
      lib/**/*
    )]
    gem.add_dependency 'capistrano', '>= 2.0'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  $stderr << "Warning: Gem-building tasks are not included as Jeweler (or a dependency) not available. Install it with: `gem install jeweler`.\n"
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "ruby-hdfs #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
