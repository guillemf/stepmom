# Ensure we require the local version and not one we might have installed already
require File.join([File.dirname(__FILE__),'lib','stepmom','version.rb'])
require File.join([File.dirname(__FILE__),'lib','stepmom','parser.rb'])
spec = Gem::Specification.new do |s| 
  s.name = 'stepmom'
  s.version = Stepmom::VERSION
  s.author = 'Guillem Fernandez'
  s.email = 'hello@guillem.mobi'
  s.homepage = 'http://blog.guillem.mobi'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Commandline utility to manage cucumber step definitions'
  s.files = `git ls-files`.split("
")
  s.require_paths << 'lib'
  s.has_rdoc = true
  s.extra_rdoc_files = ['README.rdoc','stepmom.rdoc']
  s.rdoc_options << '--title' << 'stepmom' << '--main' << 'README.rdoc' << '-ri'
  s.bindir = 'bin'
  s.executables << 'stepmom'
  s.add_development_dependency('rake')
  s.add_development_dependency('rdoc')
  s.add_development_dependency('aruba')
  s.add_development_dependency('test-unit')
  s.add_runtime_dependency('gli','2.14.0')
  s.add_runtime_dependency('rainbow', '2.1.0')
end
