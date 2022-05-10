<img alt='Rapper necklace with dollar pendant' src='https://user-images.githubusercontent.com/10758879/167485870-5c49284d-a783-453e-8be0-a3597c2ef97c.png' height='64' align='right' />

# Repper

Repper is a regular expression pretty printer for Ruby.

## Installation

`gem install repper`, or add it to your `Gemfile`.

## Usage

`repper` can be integrated into the REPL (e.g. IRB) through core extensions or used manually.

There are also a few customization options.

### Full REPL integration (recommended)

`require 'repper/core_ext/regexp'` in your `~/.irbrc` or `~/.pryrc` to override `Regexp#inspect` and automatically use `repper` to display Regexps:

<img width="313" alt="screenshot1" src="https://user-images.githubusercontent.com/10758879/167497359-e5bb94db-1382-465b-903a-3e114721b7a6.png">

### Extending Kernel#pp

Alternatively, `require 'repper/core_ext/kernel'` to make the `pp` command give nicer output for Regexps (which will look like above by default).

### Using Repper manually

```ruby
Repper.call(/foo/)   # pretty prints the given Regexp and returns nil
Repper.render(/foo/) # returns the pretty print String
```

### Customization

#### Customizing the format

The default format is the annotated, indented format shown above.

If you want to see the indented structure without annotations, use the `:structured` format.

If you only want colorization you can use the `:inline` format.

You can change the format globally:

```ruby
Repper.format = :structured
```

Or pick a format on a case-by-case basis:

<img width="445" alt="screenshot2" src="https://user-images.githubusercontent.com/10758879/167497599-105f39c7-91e0-4954-bce3-d04ad7266695.png">

Or create your own format:

```ruby
require 'csv'

csv_format = ->(elements, _theme) { elements.map(&:text).to_csv }
Repper.render(/re[\p{pe}\r]$/, format: csv_format)
=> "/,re,[,\\p{pe},\\r,],$,/\n"
```

#### Customizing the colors

The color theme can also be set globally or passed on call:

```ruby
Repper.theme = :monokai # a nicer theme, if the terminal supports it
```
<img width="316" alt="screenshot3" src="https://user-images.githubusercontent.com/10758879/167497895-0cdc017f-5c77-4b15-afaa-207f7eb887cc.png">

```ruby
Repper.call(/foo/, theme: nil) # render without colors
```

Or create your own theme - you can use all colors supported by the [`rainbow` gem](https://github.com/sickill/rainbow).

```ruby
Repper.theme = {
  group:   :green,
  set:     :red,
  default: :white,
}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jaynetics/repper.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
