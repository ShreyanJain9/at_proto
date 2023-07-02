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
  end

  def open!
  end

  def list_records(collection, limit = 10)
    list = []
    @pds_endpoint.get.com_atproto_repo_listRecords(
      repo: @did, collection: collection, limit: limit,
    )["records"].each do |record|
      list << Atmosfire::Record.new(record)
    end
    list
  end

  attr_reader :did, :record_list
end
