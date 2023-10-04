# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

desc "Default: run tests."
task default: :test

desc "Run bskyrb tests."
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.verbose = false
  t.warning = false

  if ARGV.length > 1
    t.test_files = ARGV[1..]
  else
    t.pattern = "test/**/*_test.rb"
  end
end

require "rake/extensiontask"

Rake::ExtensionTask.new "at_protocol/tid" do |ext|
  ext.lib_dir = "lib/at_protocol"
end

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = Dir.glob("spec/**/*_spec.rb")
  t.rspec_opts = "--format documentation"
end
