
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'yaml2issues'
  spec.version       = '0.0.1'
  spec.authors       = ['Kavya Sukumar']
  spec.email         = ['kavya.sukumar@outlook.com']

  spec.summary       = 'A CLI gem to create github issues from a YAML file'
  spec.description   = 'Yaml2Issues takes a YAML file and converts them to issues, tags and milestones on your github repo'
  spec.homepage      = 'https://github.com/kavyasukumar/yaml2issues'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.org'

    spec.metadata['homepage_uri'] = spec.homepage
    spec.metadata['source_code_uri'] = 'https://github.com/kavyasukumar/yaml2issues'
    spec.metadata['changelog_uri'] = 'https://github.com/kavyasukumar/yaml2issues/blob/master/CHANGELOG'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'thor', '~> 0.19.4'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
  spec.add_dependency 'activesupport', '>= 3'
  spec.add_dependency 'octokit', '~> 4.2.0'
end
