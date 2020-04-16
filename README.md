# mix-helper

Laravel Mix helper for including laravel mix assets in your templates.

[x] Support for mix-manifest files in custom directories

[x] Switch between hot reload and versioned assets without changing your templates

[x] Caches manifest files after first read to prevent repeated file access

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     mix-helper-cr:
       github: randomstate/mix-helper-cr
   ```

2. Run `shards install`

## Usage

```crystal
require "mix-helper-cr"
include Mix::Helper # typically place this in your 'master' layout template

mix "/js/app.js" 
# => //localhost:8080/js/app.js in hot-reload mode
# => //js/app.js?id=37a34fcaae4e87636c26 when using production (versioned) laravel-mix build
```

## Contributing

1. Fork it (<https://github.com/randomstate/mix-helper-cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Connor Forsyth](https://github.com/cimrie) - creator and maintainer
