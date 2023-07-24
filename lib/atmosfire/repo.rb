# typed: true

class Atmosfire::Repo
  include Atmosfire::RequestUtils
  extend T::Sig

  sig { params(username: String, pds: String, open: T::Boolean, authenticate: T.nilable(Atmosfire::Session)).void }

  # @param username [String] The username or DID (Decentralized Identifier) to use.
  # @param pds [String] The URL of the personal data server (default: "https://bsky.social").
  # @param open [Boolean] Whether to open the repository or not (default: true).
  # @param authenticate [NilClass, Object] Additional authentication data (default: nil).

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

  sig { returns(String) }

  def to_uri
    "at://#{@did}"
  end

  def to_s
    @did
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
    Collection.new(repo: self, collection: collection)
  end

  attr_reader :did, :record_list, :pds, :pds_endpoint
end
