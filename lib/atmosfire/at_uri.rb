# typed: true

module Atmosfire
  module RequestUtils
    extend T::Sig
    include Kernel

    sig { params(url: String, atp_host: String).returns(T.nilable(AtUri)) }

    def at_uri(url, atp_host = "https://bsky.social")
      AtUriParser.parse(url, AtUriParser::RuleSets, pds: atp_host)
    end
  end
end

module Atmosfire
  module AtUriParser
    extend T::Sig
    include RequestUtils

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
    RuleSets = [
      AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/(.+)/post/([\w]+)$}) do |handle, collection, rkey, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did, collection: "app.bsky.feed.post", rkey: rkey)
      end,

      AtUriParser.create_rule(%r{^at://(.+)/(.+)/(\w+)$}) do |handle, collection, rkey, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did, collection: collection, rkey: rkey)
      end,
    ]
  end

  class AtUri < T::Struct
    extend T::Sig
    const :repo, T.any(Atmosfire::Repo, String)
    const :collection, T.nilable(T.any(Atmosfire::Repo::Collection, String))
    const :rkey, T.nilable(String)

    sig { returns(String) }

    def to_s
      "at://#{repo}/#{collection}/#{rkey}"
    end
  end
end
