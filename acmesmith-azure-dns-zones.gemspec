require_relative 'lib/acmesmith-azure-dns-zones/version'

Gem::Specification.new do |spec|
  spec.name          = "acmesmith-azure-dns-zones"
  spec.version       = AcmesmithAzureDnsZones::VERSION
  spec.authors       = ["John Lin"]
  spec.email         = ["johnlinvc@gmail.com"]

  spec.summary       = %q{Acmesmith plugin for azure dns zones}
  spec.description   = %q{Acmesmith plugin for azure dns zones}
  spec.homepage      = "https://github.com/johnlinvc/acmesmith-azure-dns-zones"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = spec.homepage + "/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
