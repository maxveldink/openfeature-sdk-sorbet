# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name = "openfeature-sdk-sorbet"
  spec.version = "0.5.0"
  spec.authors = ["Max VelDink"]
  spec.email = ["maxveldink@gmail.com"]

  spec.summary = "Sorbet-aware implemention of the OpenFeature specification"
  spec.homepage = "https://github.com/maxveldink/openfeature-sdk-sorbet"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["rubygems_mfa_required"] = "true"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/maxveldink/openfeature-sdk-sorbet/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "sorbet-runtime", "~> 0.5"
  spec.add_runtime_dependency "sorbet-struct-comparable", "~> 1.3"
  spec.add_runtime_dependency "zeitwerk", "~> 2.6"
end
