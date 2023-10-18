# typed: false
module ATProto
  class Record < T::Struct
    const(:uri, ATProto::AtUri)
    const(:cid, Skyfall::CID)
    const(:timestamp, T.untyped)
    prop(:content, Hash)
    extend T::Sig
    class << self
      extend T::Sig
      include RequestUtils

      sig { params(json_hash: Hash).returns(T.nilable(ATProto::Record)) }

      def from_hash(json_hash)
        return nil if json_hash["value"].nil?
        timestamp = nil
        timestamp = Time.parse json_hash["value"]["createdAt"] if json_hash["value"] && json_hash["value"]["createdAt"]
        raw_content = json_hash["value"]
        new(
          uri: at_uri(
            T.must(json_hash["uri"])
          ),
          cid: CID.from_json(json_hash["cid"]),
          timestamp: timestamp, content: raw_content,
        )
      end

      sig { params(uri: ATProto::AtUri, pds: String).returns(T.nilable(ATProto::Record)) }

      def from_uri(uri, pds = "https://bsky.social")
        from_hash(XRPC::Client.new(pds).get.com_atproto_repo_getRecord(
          repo: uri.repo.to_s,
          collection: "#{uri.collection}",
          rkey: uri.rkey,
        ))
      end

      sig { params(content_hash: Hash, session: ATProto::Session, rkey: T.nilable(String)).returns(T.nilable(ATProto::Record)) }

      def create(content_hash, session, rkey = nil)
        return nil if content_hash["$type"].nil?
        params = {
          repo: session.did,
          collection: content_hash["$type"],
          record: content_hash,
          rkey:,
        }.compact
        from_uri(at_uri(session.xrpc.post.com_atproto_repo_createRecord(**params)["uri"]))
      end
    end
    dynamic_attr_reader(:to_uri) { "at://#{self.uri.repo}/#{self.uri.collection}/#{self.uri.rkey}" }
    dynamic_attr_reader(:strongref) { StrongRef.new(uri: self.uri, cid: self.cid) }

    def refresh(pds = "https://bsky.social")
      self.class.from_uri(self.uri, pds)
    end

    sig { params(session: ATProto::Session).returns(T.nilable(ATProto::Record)) }

    def put(session)
      session.then(&to_write(:update)).uri.resolve(pds: session.pds)
    end

    sig { params(session: ATProto::Session).returns(T.nilable(Integer)) }

    def delete(session)
      session.then(&to_write)
    end

    sig { params(type: Symbol).returns(ATProto::Writes::Write) }

    def to_write(type = :delete)
      ATProto::Writes::Write.new(
        **({
          action: Writes::Write::Action.deserialize(type),
          value: (self.content if type == :update),
          collection: self.uri.collection,
          rkey: self.uri.rkey,
        }.compact),
      )
    end

    sig { params(other: ATProto::Record).returns(T::Boolean) }

    def ==(other)
      self.cid.to_s == other.cid.to_s && self.uri.to_s == other.uri.to_s
    end
  end
end
