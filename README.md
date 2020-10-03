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
  "The user {{user.username}} with id {{user.id}} is cool",
  data
) # "The user krthr with id 123 is cool"

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

## Contributors

- [krthr](https://github.com/krthr) - creator and maintainer
