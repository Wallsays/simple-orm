# SimpleORM

Provides rails-like utilities and functionality for quering db, perfoming CRUD operations and declaring one-to-one, one-to-many, many-to-one relations.

## Installation/Usage

Clone this repo. You can work with the gem locally by either:

1. Including it in the Gemfile of some code, and pointing to the local path of the gem codebase

```
gem 'simple-orm', require: 'simple-orm', path: '/the/path/to/simple-orm'
```

2. Building and installing the gem

```
gem build simple-orm.gemspec
gem install simple-orm.gem
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/simple-orm/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request