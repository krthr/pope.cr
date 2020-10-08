# Pope.cr

> A Crystal version of [Pope](https://github.com/poppinss/pope)

A fast, minimal and micro template engine for strings only, it plays well where you want to embed micro templates inside your module.

## Installation

1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
  pope.cr:
    github: krthr/pope.cr
```

2. Run `shards install`

## Usage

See the API page > https://krthr.github.io/pope.cr/

```crystal
require "pope.cr"

data = {
  user: {
    id:       123,
    username: "krthr",
    admin:    true,
    config:   {
      email: "test@test.com",
    },
  },
}

Pope.pope(
  "The user {{user.username | upper}} with id {{user.id}} is cool",
  data
) # "The user KRTHR with id 123 is cool"


Pope.prop(data, "user.id")           #  123
Pope.prop(data, "user.config.email") # test@test.com
Pope.prop(data, "nananana")          # nil
```

## Contributing

1. Fork it (<[https://github.com/krthr/pope.cr/fork](https://github.com/krthr/pope.cr/fork)>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

### How to add additional filters Adding more filters is fairly straightforward:

1. Add another member to the `Filters` enum in `src/pope.cr`

2. Update the `Filters` enum class's static `parse` method to add a case for your filter's string identifier (so `"upper"` for the `Upper` filter, for example)

3. Update the `Filters` enum class's `apply` instance method to actually do the necessary value transformation(s)

4. Add tests for your new filter(s) (see `spec/pope_spec.cr` for examples)


## Contributors

- [krthr](https://github.com/krthr) - creator and maintainer
