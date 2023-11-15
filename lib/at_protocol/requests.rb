# typed: true

require "resolv"

module ATProto
  class Error < StandardError; end

  class HTTPError < Error; end

  class HandleNotFoundError < Error; end

  class RecordNotFoundError < Error; end

  class RepoNotFoundError < Error; end

  class UnauthorizedError < HTTPError; end

  # This error is raised if the user tried to resolve a handle to a DID that is a DID:PLC without specifying a
  # PLC directory.
  # It can be caught and converted to a proc that will resolve the handle to the PDS, when the user specifies
  # a PLC directory.
  class DidPlcDirectoryRequired < Error
    def initialize(message, did)
      super(message)
      @did = did
    end

    def to_proc
      ->plc_dir {
        RequestUtils.find_pds(@did, plc_dir)
      }
    end
  end

  module RequestUtils # Goal is to replace with pure XRPC eventually
    extend T::Sig

    module_function def resolve_handle(username, pds)
      return username if username.start_with?("did:")
      (XRPC::Client.new(pds).get.com.atproto.identity.resolveHandle[handle: username])["did"]
    end

    # @param username [String] A domain name that you intend to resolve to a DID, following ATProto conventions.
    # @return [String] A DID
    # @raise [HandleNotFoundError] if the handle could not be resolved
    module_function def manual_resolve_handle(username)
      return username if username.start_with?("did:")
      begin
        resolver = Resolv::DNS.new
        txtrecord = resolver.getresource("_atproto.#{username}", Resolv::DNS::Resource::IN::TXT).strings[0]
        return txtrecord[4..] if txtrecord.start_with?("did=")
      rescue Resolv::ResolvError
      rescue NoMethodError
      end

      did = HTTParty.get("https://#{username}/.well-known/atproto-did").body
      return did if did.start_with?("did:")

      raise HandleNotFoundError, "Could not resolve handle"
    end

    # @param username [String] A domain name linked to an ATProto Repo whose PDS you want to find.
    # @return [String] The PDS URL
    # @raise [RepoNotFoundError] if the PDS could not be found
    # @raise [DidPlcDirectoryRequired] if you did not specify a PLC directory -> rescue this!
    # @raise [HandleNotFoundError] if the handle could not be resolved
    module_function def find_pds(username, plc_dir = nil)
      did = manual_resolve_handle(username)
      didDoc = case did[4..6]
        when "web"
          JSON.parse(HTTParty.get("https://#{did[7..]}/.well_known/did.json"))
        when "plc"
          if plc_dir.nil?
            raise DidPlcDirectoryRequired.new("Did not specify PLC directory for #{did}", did)
          end
          JSON.parse(HTTParty.get("https://#{plc_dir}/#{did}"))
        end
      unless didDoc["service"].nil?
        return didDoc["service"][0]["serviceEndpoint"]
      end
      raise ATProto::RepoNotFoundError, "Could not find PDS for #{did}"
    end
  end
end
