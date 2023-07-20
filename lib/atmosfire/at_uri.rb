# typed: true

module Atmosfire
  module RequestUtils
    extend T::Sig
    include Kernel

    sig { params(url: String, pds: String).returns(T.nilable(AtUri)) }

    def at_post_link(url, pds = "https://bsky.social")
      rulesets = [
        AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/([\w.]+)/post/([\w]+)$}) do |handle, collection, rkey, pds|
          handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
          AtUri.new(did, "app.bsky.feed.post", rkey)
        end,

        AtUriParser.create_rule(%r{^at://(\[handle\])/(\[collection\])/(\[rkey\])$}) do |handle, collection, rkey, pds|
          handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
          AtUri.new(did, collection, rkey)
        end,

      ]
      AtUriParser.parse("https://bsky.app/profile/emily.bsky.team/post/3jzkm7y2u7f2e", rulesets, pds: pds)
    end
  end
end

module Atmosfire
  module AtUriParser
    extend T::Sig
    Rule = Struct.new(:pattern, :transform)

    sig { params(url: String, rulesets: T::Array[Rule], pds: String).returns(T.nilable(AtUri)) }
    def self.parse(url, rulesets, pds: "https://bsky.social")
      rulesets.each do |ruleset|
        match_data = url.match(ruleset.pattern)
        next unless match_data

        at_uri = ruleset.transform.call(match_data, pds)
        return at_uri if at_uri.is_a?(AtUri)
      end

      nil
    end

    def self.create_rule(pattern, &block)
      transform = Proc.new do |match_data, pds|
        block.call(*match_data.captures, pds)
      end
      Rule.new(pattern, transform)
    end
  end

  AtUri = Struct.new :repo, :collection, :rkey do
    extend T::Sig

    def initialize(*args)
      if args.count == 1
        parts = args[0].split("/")
        repo, collection, rkey = parts[2], parts[3], parts[4]
      elsif args.count == 3
        repo, collection, rkey = args
      end
      super(repo, collection, rkey)
    end

    sig { returns(String) }

    def to_s
      "at://#{repo}/#{collection}/#{rkey}"
    end
  end
end
