## Build Process

1. `gem build bootstrap-email.gemspec` to build the gem locally.
2. `gem install bootstrap-email-x.x.x.gem`
3. `irb`
4. `require 'bootstrap-email'`


## Release Process

1. Bump the version number in the `VERSION` file.
2. `gem build bootstrap-email.gemspec` to build the gem locally.
3. `gem push bootstrap-email-x.x.x.gem` to push the build to rubygems.org.
