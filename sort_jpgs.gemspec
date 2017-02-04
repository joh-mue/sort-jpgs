# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sort_jpgs/version'

Gem::Specification.new do |spec|
  spec.name          = 'sort_jpgs'
  spec.version       = SortJpgs::VERSION
  spec.authors       = ['joh-mue']
  spec.email         = ['yesiamkeen@gmail.com']

  spec.summary       = 'Sorts jpgs, moves and renames them'
  spec.description   = "Loads all files from a directory and it's subdirectories and moves and organizes them."
  spec.homepage      = 'http://github.com/joh-mue/sort-jpgs.rb'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'http://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'exifr', '~> 1.2.5'
  spec.add_dependency 'schlib'
end
