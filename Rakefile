# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

desc "Default: run tests."
task default: :test

require "rake/extensiontask"

gemspec = Gem::Specification.load("at_protocol.gemspec")
Rake::ExtensionTask.new do |ext|
  ext.name = "at_protocol/tid"
  ext.source_pattern = "*.{c,h}"
  ext.ext_dir = "ext/at_protocol"
  ext.lib_dir = "lib/at_protocol"
  ext.gem_spec = gemspec
end

task :default => [:compile, :spec]

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "--format documentation"
end
