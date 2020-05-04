# Interview spec
This is a base repository for interview purpose and only contains very basic gems and files

# gems
```ruby
gem 'guard'
gem 'guard-rspec'
gem 'rspec'
gem 'simplecov'
```


# ENV setup
## RSpec
```bash
rspec --init
```

```
--format documentation
--color
--require spec_helper
```

## Simplecov
```ruby
require 'simplecov'
SimpleCov.start
```

## Guard
```bash
bundle exec guard init
```

## Rubocop
```bash
rubocop --auto-gen-config
rubocop --auto-correct
```

```ymal
AllCops:
  Exclude:
    - 'path/to/excluded/file.rb'
```