require_relative "lib/repper/version"

Gem::Specification.new do |spec|
  spec.name = "repper"
  spec.version = Repper::VERSION
  spec.authors = ["Janosch Müller"]
  spec.email = ["janosch84@gmail.com"]

  spec.summary = "Regexp pretty printer for Ruby"
  spec.homepage = "https://github.com/jaynetics/repper"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jaynetics/repper"
  spec.metadata["changelog_uri"] = "https://github.com/jaynetics/repper/tree/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rainbow", "~> 3.1"
  spec.add_dependency "regexp_parser", "~> 2.4"
  spec.add_dependency "tabulo", "~> 2.8"
end
