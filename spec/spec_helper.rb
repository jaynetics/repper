require "repper"
require_relative "support/matchers"

Rainbow.enabled = true # force colors even on non-tty / dumb terminal

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def basic_regexp
  /[a]/
end

def complex_regexp
  /
    foo+?
    \K
    (?=bar)
    [\p{ascii}&&\x42-\u1234[^a-z]]
    ( qux (?:baz|bla) )
    (?(1)foo|bar)
    (?i)
    (?~baz)
    (?m-i:.\X\t\b) # comment
    \k<1>
  /x
end
