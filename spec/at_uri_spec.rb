# typed: false
RSpec.describe(Atmosfire::AtUri) do
  it("resolves to a record") do
    uri = Atmosfire::AtUri.new(repo: "did:plc:z72i7hdynmk6r22z27h6tvur", collection: "app.bsky.actor.profile", rkey: "self")
  end
end
