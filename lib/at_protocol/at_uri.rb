# typed: false

module ATProto
  module RequestUtils
    extend T::Sig
    include Kernel

    sig { params(url: String).returns(T.nilable(AtUri)) }

    module_function def at_uri(url) = AtUriParser.parse(url, AtUriParser::RuleSets)

     
  end

  def self.AtUri(str) = RequestUtils.at_uri(str)
end

module ATProto
  CID = Skyfall::CID

  module AtUriParser
    extend T::Sig

    class << self
      include RequestUtils
    end

    Rule = Struct.new(:pattern, :transform)

    sig { params(url: T.any(String, AtUri), rulesets: T::Array[Rule]).returns(T.nilable(AtUri)) }
    def self.parse(url, rulesets)
      return url if url.is_a?(AtUri)
      rulesets.each do |ruleset|
        match_data = url.match(ruleset.pattern)
        next unless match_data

        at_uri = ruleset.transform.call(match_data)
        return at_uri if at_uri.is_a?(AtUri)
      end
      nil
    end

    def self.create_rule(pattern, &block)
      transform = Proc.new do |match_data|
        block.call(*match_data.captures)
      end
      Rule.new(pattern, transform)
    end
    RuleSets = [
      AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/(.+)/post/([\w]+)$}) do |_, handle, rkey|
        handle.start_with?("did:") ? did = handle : did = manual_resolve_handle(handle)
        AtUri.new(repo: did, collection: "app.bsky.feed.post", rkey: rkey)
      end,

      AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/(.+)$}) do |_, handle|
        handle.start_with?("did:") ? did = handle : did = manual_resolve_handle(handle)
        AtUri.new(repo: did)
      end,

      AtUriParser.create_rule(%r{^at://(.+)/(.+)/(\w+)$}) do |handle, collection, rkey|
        handle.start_with?("did:") ? did = handle : did = manual_resolve_handle(handle)
        AtUri.new(repo: did, collection: collection, rkey: rkey)
      end,
      AtUriParser.create_rule(%r{^at://(.+)/(.+)$}) do |handle, collection|
        handle.start_with?("did:") ? did = handle : did = manual_resolve_handle(handle)
        AtUri.new(repo: did, collection: collection)
      end,
      AtUriParser.create_rule(%r{^at://(.+)$}) do |handle|
        handle.start_with?("did:") ? did = handle : did = manual_resolve_handle(handle)
        AtUri.new(repo: did)
      end,
    ]
  end

  class AtUri < T::Struct
    extend T::Sig
    const :repo, T.any(ATProto::Repo, String)
    const :collection, T.nilable(T.any(ATProto::Repo::Collection, String))
    const :rkey, T.nilable(String)
    const :query, T.nilable(Hash)
    const :fragment, T.nilable(String)

    def resolve(pds:)
      if @collection.nil?
        Repo.new(@repo.to_s, pds)
      elsif @rkey.nil?
        Repo::Collection.new(Repo.new(@repo.to_s, pds), @collection.to_s, pds)
      else
        Record.from_uri(self, pds)
      end
    end

    sig { returns(String) }

    def to_s = "at://#{@repo}/#{@collection.nil? ? "" : "#{@collection}/"}#{@rkey}"
  end
end
