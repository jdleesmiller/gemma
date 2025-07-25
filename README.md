# gemma

https://github.com/jdleesmiller/gemma  

https://github.com/jdleesmiller/gemma/wiki

[![Build Status](https://github.com/jdleesmiller/gemma/actions/workflows/ci.yml/badge.svg)](https://github.com/jdleesmiller/gemma/actions/workflows/ci.yml)
[![Dependency Status](https://gemnasium.com/jdleesmiller/gemma.png)](https://gemnasium.com/jdleesmiller/gemma)
[![Gem Version](https://badge.fury.io/rb/gemma.png)](http://badge.fury.io/rb/gemma)

## SYNOPSIS

Gemma is a gem development helper like hoe and jeweler, but it keeps the
`gemspec` in a `.gemspec` file, instead of in a `Rakefile`. This helps
your gem to play nicely with commands like `gem` and `bundle`, and it allows
gemma to provide `rake` tasks with sensible defaults for many common gem
development tasks.

See [this blog post](http://yehudakatz.com/2010/04/02/using-gemspecs-as-intended) for some reasons
why you probably want a `.gemspec` file in your gem's repository.

### Usage

See the project wiki for tutorials and guides:  
https://github.com/jdleesmiller/gemma/wiki

Briefly:

#### Create a New Gem

Gemma has a simple interactive gem scaffolding tool; run

```sh
gemma new
```

and follow the prompts. (Run with -h for help.)

This gives you a simple gem template like the following:

```
my_gem
|-- bin
|   `-- my_gem           # executable (optional)
|-- Gemfile              # for bundler (see below)
|-- lib
|   |-- my_gem           # most of your code goes here
|   |   `-- version.rb   # the version constant
|   `-- my_gem.rb        # the main code file
|-- my_gem.gemspec       # gem metadata
|-- Rakefile             # development tasks
|-- README.md            # documentation
`-- test                 # unit tests go here
    `-- my_gem
        `-- my_gem_test.rb
```

Things you need to change in the template are marked with a `TODO` tag.

#### To Modify an Existing Gem to use Gemma

The main thing you need is a `.gemspec` file. If you have been using hoe
or jeweler, you already have all of the information in your Rakefile, so you
just have to move it into a `.gemspec` file.

Gemma provides rake tasks with sensible defaults based on the contents of
your gemspec; to enable them, add the following to the top of your `Rakefile`:

```ruby
require 'rubygems'
require 'bundler/setup'
require 'gemma'

Gemma::RakeTasks.with_gemspec_file 'my_gem.gemspec'

task default: :test
```

This gives you some standard rake tasks, in addition to any that you define
yourself.

#### The Standard Tasks

Run `rake -T` for a full list of tasks.

```
rake build         # Build my_gem-0.0.1.gem into the pkg directory
rake clean         # Remove any temporary products.
rake clobber       # Remove any generated file.
rake clobber_rdoc  # Remove RDoc HTML files
rake install       # Build and install my_gem-0.0.1.gem into system gems
rake rdoc          # Build RDoc HTML files
rake release       # Create tag v0.0.1 and build and push my_gem-0.0.1.gem ...
rake rerdoc        # Rebuild RDoc HTML files
rake test          # Run tests
rake yard          # Generate YARD Documentation
```

You can customize the standard tasks by passing a block to `with_gemspec_file`:

```ruby
Gemma::RakeTasks.with_gemspec_file 'mygem.gemspec' do |g|
  g.rdoc.title = 'My Gem Is Great'
end
```

See the gemma API docs for more information.

## INSTALLATION

```sh
gem install gemma
```

## DEVELOPMENT

```sh
git clone git://github.com/jdleesmiller/gemma.git
cd gemma
bundle
rake -T # list development tasks
```

## TODO

- make it easier to add custom tasks and / or new task generators, as in

  ```ruby
  # DOES NOT WORK YET
  Gemma::RakeTasks.with_gemspec_file 'mygem.gemspec' do |g|
    g.yard_dev = Gemma::RakeTasks::YardTasks.new(g.gemspec, :yard_dev)
    g.yard_dev.output = 'dev_docs'
    g.yard_dev.options.push('--protected', '--private')
  end
  ```

- more tasks (e.g. to publish docs)
- more tasks to support C extensions
- hooks for the rcov and/or simplecov coverage tools
- tasks for version control? (e.g. based on http://github.com/nvie/gitflow)
- contributions welcome!

## HISTORY

**6.0.0**
- updated dependencies
- dropped support for rubies < 3 (use 5.x for older rubies)

**5.0.1**
- fix rake testtask to avoid `cannot load such file -- ubygems` in ruby 2.5.0

**5.0.0**
- updated dependencies
- added rubocop as a dependency and lint the code and the template
- converted the template readme to markdown
- dropped support for rubies < 2.3 (use 4.x for older rubies)

**4.1.0**
- updated dependencies

**4.0.0**
- updated dependencies
- removed RunTasks -- bundler handles this now

**3.0.0**
- updated dependencies

**2.2.0**
- updated dependencies; now using bundler 1.1

**2.1.0**
- updated dependencies

**2.0.0**
- now relies on bundler
- now specifies particular gem version that must be used for rake, rdoc and
  yard; the old approach was to try to work with whatever was already installed,
  but this proved too fragile
- removed rcov support, because it doesn't work on 1.9.x (see simplecov)

**1.0.0**
- added templates
- changed rdoc and yard tasks to use `require_paths` instead of `files`
- more tests
- more documentation

**0.0.2**
- minor fixes

**0.0.1**
- first release

## LICENSE

Copyright (c) 2010-2025 John Lees-Miller

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
