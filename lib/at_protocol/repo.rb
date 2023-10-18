# typed: true

class ATProto::Repo
  include ATProto::RequestUtils
  extend T::Sig

  sig { params(username: String, pds: String, open: T::Boolean, authenticate: T.nilable(ATProto::Session)).void }

  # @param username [String] The username or DID (Decentralized Identifier) to use.
  # @param pds [String] The URL of the personal data server (default: "https://bsky.social").
  # @param open [Boolean] Whether to open the repository or not (default: true).
  # @param authenticate [NilClass, Object] Additional authentication data (default: nil).
  def initialize(username, pds, open: true, authenticate: nil)
    @pds = T.let pds, String
    @xrpc = T.let(XRPC::Client.new(pds), XRPC::Client)
    if username.start_with?("did:")
      @did = T.let(username, String)
    else
      @did = T.let(resolve_handle(username, pds), String)
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
    "at://#{@did}/"
  end

  sig { returns(String) }

  def to_s
    @did
  end

  sig { returns(Hash) }

  def describe_repo
    @xrpc.get.com_atproto_repo_describeRepo(repo: @did)
  end

  sig { returns(Hash) }

  def did_document
    describe_repo()["didDoc"]
  end

  sig { params(collection: String).returns(ATProto::Repo::Collection) }

  def [](collection)
    Collection.new(repo: self, collection: collection)
  end

  def inspect
    "Repo(#{@did})"
  end

  attr_reader :did, :record_list, :pds, :xrpc
end
