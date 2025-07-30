# frozen_string_literal: true

require_relative 'lib/db_transformer/version'

Gem::Specification.new do |spec|
  spec.name          = 'db_transformer'
  spec.version       = DbTransformer::VERSION
  spec.authors       = ['Tomoki Ichikawa']
  spec.email         = ['ichikawa@1060ki.com']

  spec.summary       = ''
  spec.description   = ''
  spec.homepage      = 'https://github.com/1060ki/db_transformer'
  spec.required_ruby_version = '>= 2.7.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/1060ki/db_transformer'
  # spec.metadata["changelog_uri"] = ""

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faker'
  spec.add_dependency 'trilogy', "~> 2.9"
  spec.add_dependency 'sequel', '~> 5.56'
  spec.add_dependency 'thor', '~> 1.2'
  spec.add_dependency 'parallel', '~> 1.22'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
