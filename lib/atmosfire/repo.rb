class Atmosfire::Repo
  include Atmosfire::RequestUtils

  def initialize(pds, username, open: true, authenticate: nil)
    @pds_endpoint = XRPC::Client.new(pds)
    if username.start_with?("did:")
      @did = username
    else
      @did = resolve_handle(pds, username)
    end
    @record_list = []
    if open == true
      open!
    end
  end

  def open!
    @collections = describe_repo["collections"]
  end

  def describe_repo
    @pds_endpoint.get.com_atproto_repo_describeRepo(repo: @did)
  end

  def list_records(collection, limit = 10)
    @pds_endpoint.get.com_atproto_repo_listRecords(
      repo: @did, collection: collection, limit: limit,
    )["records"].map { |record| Atmosfire::Record.from_hash(record) }
  end

  def did_document()
    describe_repo()["didDoc"]
  end

  attr_reader :did, :record_list
end
