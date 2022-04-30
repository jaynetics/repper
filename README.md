# Repper
<img alt='Rapper necklace with dollar pendant' src='https://user-images.githubusercontent.com/10758879/167485870-5c49284d-a783-453e-8be0-a3597c2ef97c.png' style='float: left; margin: -84px 0 0 90px; height: 53px;' />

Repper is a regular expression pretty printer for Ruby.

## Installation

`gem install repper`, or add it to your `Gemfile`.

## Usage

`repper` can be integrated into the REPL (e.g. IRB) through core extensions or used manually.

There are also a few customization options.

### Full REPL integration (recommended)

`require 'repper/core_ext/regexp'` in your `~/.irbrc` or `~/.pryrc` to override `Regexp#inspect` and automatically use `repper` to display Regexps:

<pre style='background-color: #111; color: #DDD;'>
irb(main):001:0> /re[\p{pe}\r]$/
=>
 <span style='color:red'>/</span>
   <span style='color:red'>ra</span>           literal
   <span style='color:cyan'>[</span>            character set
     <span style='color:red'>p</span>          literal
     <span style='color:cyan'>\p{pe}</span>     close punctuation property
     <span style='color:red'>\r</span>         carriage escape
   <span style='color:cyan'>]</span>            character set
   <span style='color:yellow'>$</span>            eol anchor
 <span style='color:red'>/</span>
</pre>

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

<pre style='background-color: #111; color: #DDD;'>
irb(main):001:0> Repper.call(/re[\p{pe}\r]$/, format: :inline)
=> <span style='color:red'>/</span><span style='color:red'>re</span><span style='color:cyan'>[</span><span style='color:red'>p</span><span style='color:cyan'>\p{pe}</span><span style='color:red'>\r</span><span style='color:cyan'>]</span><span style='color:yellow'>$</span><span style='color:red'>/</span>
</pre>

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
