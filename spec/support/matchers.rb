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

  attr_reader :actual, :expected

  match do |actual|
    @actual = raw_text(actual)
    @expected = expected.chomp
    @actual == @expected
  end
end

# ignore color escapes and tabulo padding when diffing
def raw_text(str)
  str.gsub(COLOR_ESCAPE_REGEXP, '').gsub(/^ ( {2}*\S)| *$/, '\1')
end

RSpec::Matchers.define :be_functionally_equivalent_to do |expected_regexp|
  diffable

  attr_reader :actual, :expected

  match do |actual_regexp_string|
    actual_regexp = eval(actual_regexp_string)
    @actual = normalize(actual_regexp)
    @expected = normalize(expected_regexp)

    @actual == @expected
  end

  def normalize(regexp)
    tree = Regexp::Parser.parse(regexp)
    remove_free_space(tree)
    tree.to_re
  end

  def remove_free_space(exp)
    return if exp.terminal?

    exp.expressions.reject! { |subexp| subexp.one_of?(%i[whitespace comment]) }
    exp.expressions.each { |subexp| remove_free_space(subexp) }
  end
end
