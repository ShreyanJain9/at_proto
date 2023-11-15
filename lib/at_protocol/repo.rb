# typed: true

class ATProto::Repo
  include ATProto::RequestUtils
  extend T::Sig
  attr_reader :did, :record_list, :pds, :xrpc
  alias_method :to_s, :did

  # @param username [String] The username or DID (Decentralized Identifier) to use.
  # @param pds [String] The URL of the personal data server.
  # @param open [Boolean] Whether to hydrate the repository data or not (default: false).
  def initialize(username, pds, open: false)
    @pds = T.let pds, String
    @xrpc = T.let XRPC::Client.new(pds), XRPC::Client
    @did = T.let resolve_handle(username, pds), String
    open! if open
  end

  def open!; @collections = describe["collections"]; end

  sig { returns(String) }

  def to_uri = "at://#{did}/"

  # @return [Hash] JSON data which describes the Repo, including its collections, handle, DID doc, etc.
  def describe = @description ||= @xrpc.get.com.atproto.repo.describeRepo[repo: @did]

  sig { returns(Hash) }

  def did_doc = describe["didDoc"]

  sig { params(collection: String).returns(ATProto::Repo::Collection) }

  def [](collection) = Collection.new(repo: self, collection: collection)

  def inspect = "Repo(#{@did})"
end
