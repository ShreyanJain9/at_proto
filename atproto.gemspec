lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "atproto/version"

specfiles = Dir["./lib/atproto/*"]
specfiles.push("./lib/atproto.rb")

Gem::Specification.new do |spec|
  spec.name = "ATProto"
  spec.version = ATProto::VERSION
  spec.authors = ["Shreyan Jain", "Tynan Burke"]
  spec.email = ["shreyan.jain.9@outlook.com"]
  spec.description = "A Ruby gem for interacting with atproto"
  spec.summary = "Interact with the AT Protocol using Ruby"
  spec.homepage = "https://github.com/ShreyanJain9/atproto"
  spec.license = "MIT"
  spec.files = specfiles
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "json", ">= 2.0"
  spec.add_runtime_dependency "date", ">= 3.3.3"
  spec.add_runtime_dependency "httparty", ">= 0.21.0"
  spec.add_runtime_dependency "xrpc", ">= 0.0.4"
end
