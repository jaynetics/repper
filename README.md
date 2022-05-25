<img alt='Rapper necklace with dollar pendant' src='https://user-images.githubusercontent.com/10758879/167485870-5c49284d-a783-453e-8be0-a3597c2ef97c.png' height='64' align='right' />

# Repper

Repper is a regular expression pretty printer and formatter for Ruby.

## Installation

`gem install repper`, or add it to your `Gemfile`.

## Usage

`repper` can be integrated into the REPL (e.g. IRB) through core extensions for Regexp pretty-printing, integrated into editors to format Regexps, or called manually.

There are also a few customization options.

### REPL integration

#### Via Regexp#inspect (recommended)

`require 'repper/core_ext/regexp'` in your `~/.irbrc` or `~/.pryrc` to override `Regexp#inspect` and automatically use `repper` to display Regexps:

<img width="475" alt="screenshot1" src="https://user-images.githubusercontent.com/10758879/167719748-60f4013a-c8d4-4a62-843a-d9f27057bcd3.png">

#### Via Kernel#pp

Alternatively, `require 'repper/core_ext/kernel'` to make the `pp` command give nicer output for Regexps (which will look like above by default).

### Editor integration

Use [vscode-repper](https://github.com/jaynetics/vscode-repper) to format Regexps in VSCode.

![vscode-repper](https://user-images.githubusercontent.com/10758879/170892739-e2f408f2-e239-4b13-8d28-c14fb7a9dbb9.gif)

### Using Repper manually

```ruby
Repper.call(/foo/)   # pretty prints the given Regexp and returns nil
Repper.render(/foo/) # returns the pretty print String
```

### Customization

#### Customizing the format

Multiple formats are available out of the box:

- `:annotated` is the default, verbose format, shown above
- `:inline` adds only colorization and does not restructure the Regexp
- `:structured` is like `:annotated`, just without annotations
- `:x` (or `:extended`) returns a lightly formatted but equivalent Regexp
  - this format is used for the repper executable and [vscode-repper](https://github.com/jaynetics/vscode-repper)

You can change the format globally:

```ruby
Repper.format = :structured
```

Or pick a format on a case-by-case basis:

<img width="711" alt="screenshot2" src="https://user-images.githubusercontent.com/10758879/167719567-ae8ee42f-839e-4ce4-af56-a139044d3436.png">

Or create your own format:

```ruby
require 'csv'

csv_format = ->(tokens, _theme) { tokens.map(&:text).to_csv }
Repper.render(/re[\p{pe}\r]$/, format: csv_format)
=> "/,re,[,\\p{pe},\\r,],$,/\n"
```

#### Customizing the colors

The color theme can also be set globally or passed on call:

```ruby
Repper.theme = :monokai # a nicer theme, if the terminal supports it
```

<img width="478" alt="screenshot3" src="https://user-images.githubusercontent.com/10758879/167719807-9170ba92-48d1-4669-a05d-a72f962b961d.png">

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
