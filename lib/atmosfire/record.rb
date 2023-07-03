module Atmosfire
  Record = Struct.new :uri, :cid, :collection, :timestamp, :content do
    class << self
      def from_hash(json_hash)
        timestamp = Time.parse json_hash["value"]["createdAt"]
        raw_content = json_hash["value"]
        new(AtUri.new(json_hash["uri"]), json_hash["cid"], json_hash["value"]["$type"], timestamp, raw_content)
      end

      def from_uri(uri, pds = "https://bsky.social")
        url = AtUri.new(uri.to_s)
        self.from_hash XRPC::Client.new(pds).get.com_atproto_repo_getRecord(repo: url.repo, collection: url.collection, rkey: url.rkey)
      end
    end

    def delete(session)
      # pass a session as an argument to use as the authentication for deletion
      data = { collection: self.collection, repo: session.did, rkey: self.uri.rkey }
      HTTParty.post(
        delete_record_uri(session.pds),
        body: data.to_json,
        headers: default_authenticated_headers(session),
      )
    end
  end
end
