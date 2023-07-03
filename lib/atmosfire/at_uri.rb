module Atmosfire
  module RequestUtils
    def at_post_link(pds, url)
      url = url.to_s.strip

      if url.start_with?("at://")
        parts = url.split("/")
        raise "The provided URL #{url} is not a valid AT URL" unless parts.length == 5 && parts[3] == "app.bsky.feed.post"
        username, post_id = parts[2], parts[4]
      elsif url.start_with?("https://")
        username, post_id = url.split("/")[-3], url.split("/")[-1]
        raise "The provided URL #{url} does not match the expected schema" unless not username.empty?
      else
        raise "Unsupported URL format: #{url}"
      end

      did = username.start_with?("did:") ? username : resolve_handle(pds, username)["did"]
      "at://#{did}/app.bsky.feed.post/#{post_id}"
    end
  end
end

module Atmosfire
  AtUri = Struct.new :repo, :collection, :rkey do
    def initialize(*args)
      if args.count == 1
        parts = args[0].split("/")
        repo, collection, rkey = parts[2], parts[3], parts[4]
      elsif args.count == 3
        repo, collection, rkey = args
      end
      super(repo, collection, rkey)
    end

    def to_s
      "at://#{repo}/#{collection}/#{rkey}"
    end
  end
end
