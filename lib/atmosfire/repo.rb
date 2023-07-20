# typed: true

class Atmosfire::Repo
  include Atmosfire::RequestUtils
  extend T::Sig

  sig { params(username: String, pds: String, open: T::Boolean, authenticate: T.nilable(Atmosfire::Session)).void }

  def initialize(username, pds = "https://bsky.social", open: true, authenticate: nil)
    @pds = pds
    @pds_endpoint = XRPC::Client.new(pds)
    if username.start_with?("did:")
      @did = username
    else
      @did = resolve_handle(username, pds)
    end
    @record_list = []
    if open == true
      open!
    end
  end

  def open!
    @collections = describe_repo["collections"]
  end

  sig { returns(Hash) }

  def describe_repo
    @pds_endpoint.get.com_atproto_repo_describeRepo(repo: @did)
  end

  sig { returns(Hash) }

  def did_document
    describe_repo()["didDoc"]
  end

  sig { params(collection: String).returns(Atmosfire::Repo::Collection) }

  def [](collection)
    Collection.new(self, collection)
  end

  attr_reader :did, :record_list, :pds, :pds_endpoint
end
