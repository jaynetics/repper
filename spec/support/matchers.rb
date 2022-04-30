COLOR_ESCAPE_REGEXP = /\e\[[0-9;]*m/

RSpec::Matchers.define :have_color do
  match do |actual|
    COLOR_ESCAPE_REGEXP.match?(actual)
  end

  failure_message do |actual|
    "expected #{actual} to have ANSI color escapes"
  end

  failure_message_when_negated do |actual|
    "expected #{actual} not to have ANSI color escapes"
  end
end

RSpec::Matchers.define :have_raw_text do |expected|
  diffable

  match do |actual|
    # ignore color escapes and tabulo padding when diffing
    @actual = actual.gsub(COLOR_ESCAPE_REGEXP, '').gsub(/^ ( {2}*\S)| *$/, '\1')
    @expected = expected.chomp
    @actual == @expected
  end
end
