# typed: true
module Atmosfire
  Record = Struct.new :uri, :cid, :timestamp, :content do
    extend T::Sig
    class << self
      extend T::Sig

      sig { params(json_hash: Hash).returns(T.nilable(Atmosfire::Record)) }

      def from_hash(json_hash)
        return nil unless json_hash["value"]
        timestamp = nil
        timestamp = Time.parse json_hash["value"]["createdAt"] if json_hash["value"]["createdAt"]
        raw_content = json_hash["value"]
        new(AtUri.new(json_hash["uri"]), json_hash["cid"], timestamp, raw_content)
      end

      sig { params(uri: T.any(String, Atmosfire::AtUri), pds: String).returns(T.nilable(Atmosfire::Record)) }

      def from_uri(uri, pds = "https://bsky.social")
        url = AtUri.new(uri.to_s)
        self.from_hash XRPC::Client.new(pds).get.com_atproto_repo_getRecord(
          repo: url.repo,
          collection: url.collection,
          rkey: url.rkey,
        )
      end

      sig { params(content_hash: Hash, session: Atmosfire::Session, rkey: T.nilable(String)).returns(T.nilable(Atmosfire::Record)) }

      def create(content_hash, session, rkey = nil)
        return nil if content_hash["$type"].nil?
        if rkey.nil?
          rec = from_uri(session.xrpc.post.com_atproto_repo_createRecord(
            repo: session.did,
            collection: content_hash["$type"],
            record: content_hash,
          )["uri"])
          return rec
        else rec = from_uri(session.xrpc.post.com_atproto_repo_createRecord(
          repo: session.did,
          collection: content_hash["$type"],
          rkey: rkey,
          record: content_hash,
        )["uri"])
          return rec;         end
      end
    end

    def refresh(pds = "https://bsky.social")
      self.class.from_uri(self.uri, pds)
    end

    sig { params(session: Atmosfire::Session).returns(T.nilable(Atmosfire::Record)) }

    def update(session)
      self.delete(session)
      session.xrpc.post.com_atproto_repo_createRecord(
        repo: session.did,
        collection: self.uri.collection,
        rkey: self.uri.rkey,
        record: self.content,
      )
      self.class.from_uri(self.uri, session.pds)
    end

    def put(session)
      session.xrpc.post.com_atproto_repo_putRecord(
        repo: session.did,
        collection: self.uri.collection,
        rkey: self.uri.rkey,
        record: self.content,
      )
    end

    sig { params(session: Atmosfire::Session).returns(T.nilable(Integer)) }

    def delete(session)
      session.xrpc.post.com_atproto_repo_deleteRecord(
        repo: session.did,
        collection: self.uri.collection,
        rkey: self.uri.rkey,
      )
    end
  end
end
