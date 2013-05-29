Gem::Specification.new do |s|
 s.name    = 'capistrano-syntax-checking'
 s.version = '0.1.3'
 s.summary = 'Capistrano extension that adds syntax checks for Ruby, ERB and JavaScript files.'

 s.author   = 'Alexander Staubo'
 s.email    = 'alex@bengler.no'
 s.homepage = 'https://github.com/hoyaemt/capistrano-syntax-checking'

 # Include everything in the lib folder
 s.files = Dir['lib/**/*']

 # Supress the warning about no rubyforge project
 s.rubyforge_project = 'nowarning'
end
