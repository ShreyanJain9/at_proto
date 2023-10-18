# typed: false

module ATProto
  module RequestUtils
    extend T::Sig
    include Kernel

    sig { params(url: String, atp_host: String).returns(T.nilable(AtUri)) }

    def at_uri(url, atp_host)
      AtUriParser.parse(url, AtUriParser::RuleSets, pds: atp_host)
    end

    module_function :at_uri
  end

  def self.AtUri(str)
    RequestUtils.at_uri(str)
  end
end

module ATProto
  CID = Skyfall::CID

  module AtUriParser
    extend T::Sig

    class << self
      include RequestUtils
    end

    Rule = Struct.new(:pattern, :transform)

    sig { params(url: T.any(String, AtUri), rulesets: T::Array[Rule], pds: String).returns(T.nilable(AtUri)) }
    def self.parse(url, rulesets, pds:)
      return url if url.is_a?(AtUri)
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
      AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/(.+)/post/([\w]+)$}) do |_, handle, rkey, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did, collection: "app.bsky.feed.post", rkey: rkey)
      end,

      AtUriParser.create_rule(%r{^#{Regexp.escape("https://")}(bsky\.app)/profile/(.+)$}) do |_, handle, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did)
      end,

      AtUriParser.create_rule(%r{^at://(.+)/(.+)/(\w+)$}) do |handle, collection, rkey, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did, collection: collection, rkey: rkey)
      end,
      AtUriParser.create_rule(%r{^at://(.+)/(.+)$}) do |handle, collection, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did, collection: collection)
      end,
      AtUriParser.create_rule(%r{^at://(.+)$}) do |handle, pds|
        handle.start_with?("did:") ? did = handle : did = resolve_handle(handle, pds)
        AtUri.new(repo: did)
      end,

    ]
  end

  class AtUri < T::Struct
    extend T::Sig
    const :repo, T.any(ATProto::Repo, String)
    const :collection, T.nilable(T.any(ATProto::Repo::Collection, String))
    const :rkey, T.nilable(String)

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

    def to_s
      "at://#{@repo}/#{@collection.nil? ? "" : "#{@collection}/"}#{@rkey}"
    end
  end
end
