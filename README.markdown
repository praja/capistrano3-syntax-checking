This is a simple extension to Capistrano that adds a few tasks to syntax-check source files.

Installation
------------

Install via gems:

    gem install capistrano-syntax-checking

Usage with Rails
----------------

To use with a Rails application with sensible default, put the following at the 
top of your `Capfile`:

    require 'capistrano/recipes/syntax_checking'

Then add this at the bottom of your `Capfile`, _outside_ the `namespace deploy do ...`
block:

    before 'deploy:update', :check_syntax

To invoke only certain checks, such as only Ruby and ERB:

    before 'deploy:update', "check_syntax:ruby"
    before 'deploy:update', "check_syntax:erb"
    
Usage with generic (non-Rails) application, or when you want to be in control
-----------------------------------------------------------------------------

To use with any other kind of application, you will want to use your own tasks 
that providecustom options to the syntax-checker. Start by putting this at the 
top of your `Capfile`:

    require 'capistrano/ext/syntax_checking'

Then build your own tasks by calling the syntax check API, perhaps like this:

    task :deploy do
      Capistrano::SyntaxChecking.check_javascript('src', :verbose => false)
    end

Licensing
---------

* This source code is copyright Alexander Staubo. The code is licensed under the
  MIT license. See LICENSE for the license text.

* The library comes with a binary compiled version of the Google Closure 
  compiler, which is copyright Google Corp. and licensed under the Apache License.
  See the file LICENSE.closure for the license text.
