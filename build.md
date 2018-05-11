## Build Process

1. Bump the version number in the `VERSION` file.
2. `gem build bootstrap-email.gemspec` to build them gem locally.
3. `gem push bootstrap-email-0.2.1.gem` to push the build to rubygems.org.
4. `gem install ./bootstrap-email-0.2.1.gem`
5. `irb`
6. `require 'bootstrap-email'`
