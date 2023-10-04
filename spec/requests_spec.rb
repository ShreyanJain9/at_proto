# typed: false
RSpec.describe(ATProto::RequestUtils) do
  describe "#at_uri" do
    it "successfully parses a bsky.app post url" do
      real_uri = ATProto::AtUri.new(
        repo: resolve_handle("bsky.app"), collection: "app.bsky.feed.post", rkey: "3juhccum3pv2k",
      )
      parsed_uri = at_uri("https://bsky.app/profile/bsky.app/post/3juhccum3pv2k")
      expect(real_uri.to_s).to eq(parsed_uri.to_s)
    end
  end
  describe "#resolve_handle" do
    it "successfully resolves a handle" do
      expect(resolve_handle("bsky.app")).to eq("did:plc:z72i7hdynmk6r22z27h6tvur")
    end
  end
end
