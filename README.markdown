This is a simple extension to Capistrano that adds a few pre-deploy 
syntax-checks for source files.

Currently supported syntaxes are Ruby, ERB, JavaScript (using the Google
Closure compiler) and HAML.

Installation
------------

Install via gems:

    gem install capistrano-syntax-checking

Usage with Rails and Capistrano's standard Rails recipe
-------------------------------------------------------

To use with a Rails application with sensible default, put the following at the 
top of your `Capfile`:

    require 'capistrano/recipes/syntax_checking'

Then add this at the bottom of your `Capfile`, _outside_ the `namespace deploy do ...`
block:

    before 'deploy:update', :check_syntax

To invoke only certain checks, such as only Ruby and ERB:

    before 'deploy:update', "check_syntax:ruby"
    before 'deploy:update', "check_syntax:erb"
    
Using without Capistrano's standard Rails recipe, or with non-Rails apps
------------------------------------------------------------------------

If you are not using the Capistrano's built-in Rails support, start the same way:

    require 'capistrano/recipes/syntax_checking'

Then override all the paths to match your application exactly:

    set :syntax_check_paths,
      :ruby => ["lib/ruby"]     # These are just examples
      :erb => ["lib/erb"],
      :javascript => ["public/js"]
      
Then make sure the syntax checks are invoked before your deploy task. If your
deploy task is named "push", then:

    desc "Full deploy ahead!"
    task :push do
      # ... your stuff here ...
    end
    before :push, :check_syntax
    
Refer to Capistrano's documentation on how to otherwise structure your 
deployment file.

Using the API directly
----------------------

To use with any other kind of application, you will want to use your own tasks 
that provide custom options to the syntax-checker. Start by putting this at the 
top of your `Capfile`:

    require 'capistrano/ext/syntax_checking'

Then build your own tasks by calling the syntax check API, perhaps like this:

    task :deploy do
      Capistrano::SyntaxChecking.check_javascript('src', :verbose => false)
    end

Configuration
-------------

You can override the paths that the checker will look in. For the Rails
recipe, the paths are the usual directoryes -- `app`, `lib` and `config` for
Ruby files, `app/views` for ERB, and so on. If your Rails layout is a little
different, then you may have to extend the path list.

To override the path list, set the `syntax_check_paths` variable in
Capistrano. For example:

    set :syntax_check_paths, :ruby => %w(app lib bin config vendor)
    
The keys you may override are `:ruby`, `:erb`, `:javascript` and `:haml`.

You can also override the task output verbosity:

     set :syntax_check_verbose, false

Licensing
---------

* This source code is copyright Alexander Staubo. The code is licensed under the
  MIT license. See LICENSE for the license text.

* The library comes with a binary compiled version of the Google Closure 
  compiler, which is copyright Google Corp. and licensed under the Apache License.
  See the file LICENSE.closure for the license text.
