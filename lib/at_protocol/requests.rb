# typed: true

require "resolv"

module ATProto
  class Error < StandardError; end

  class HTTPError < Error; end

  class Error::HandleNotFound < Error; end

  class Error::RecordNotFound < Error; end

  class Error::RepoNotFound < Error; end

  class Error::Unauthorized < HTTPError; end

  # This error is raised if the user tried to resolve a handle to a DID that is a DID:PLC without specifying a
  # PLC directory.
  # It can be caught and converted to a proc that will resolve the handle to the PDS, when the user specifies
  # a PLC directory.
  class Error::DidPlcDirectoryRequired < Error
    def initialize(did, method)
      message = "Did not specify PLC directory for #{did}"
      super(message)
      @did = did
    end

    def to_proc
      ->plc_dir {
        RequestUtils.send(method, @did, plc_dir)
      }
    end
  end

  module RequestUtils # Goal is to replace with pure XRPC eventually
    extend T::Sig
    module_function
    def resolve_handle(username, pds)
      return username if username.start_with?("did:")
      (XRPC::Client.new(pds).get.com.atproto.identity.resolveHandle[handle: username])["did"]
    end

    # @param username [String] A domain name that you intend to resolve to a DID, following ATProto conventions.
    # @return [String] A DID
    # @raise [HandleNotFoundError] if the handle could not be resolved
     def manual_resolve_handle(username)
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

      raise Error::HandleNotFound, "Could not resolve handle"
    end

    # @param username [String] A domain name linked to an ATProto Repo whose PDS you want to find.
    # @return [String] The PDS URL
    # @raise [Error::RepoNotFound] if the PDS could not be found
    # @raise [Error::DidPlcDirectoryRequired] if you did not specify a PLC directory -> rescue this!
    # @raise [Error::HandleNotFound] if the handle could not be resolved
    def find_pds(username, plc_dir = nil)
      didDoc = get_did_doc(username, plc_dir, return_hook: :find_pds)
      unless didDoc["service"].nil?
        return didDoc["service"][0]["serviceEndpoint"]
      else 
        raise Error::RepoNotFound, "Could not determine PDS for #{username}"
      end
    end

    # @param username [String] A domain name or DID whose DID Document you want. 
    # @param plc_dir [String] The PLC directory to fetch did:plc documents from. Optional if using did:web. 
    # @param return_hook [Symbol] DO NOT USE, PRIVATE API
    # @return [Hash] The DID doc.
    # @raise [Error::RepoNotFound] if the PDS could not be found
    # @raise [Error::DidPlcDirectoryRequired] if you did not specify a PLC directory -> rescue this!
    # @raise [Error::HandleNotFound] if the handle could not be resolved
    def get_did_doc(username, plc_dir = nil, return_hook: nil)
      did = manual_resolve_handle(username)
      case did[4..6]
        when "web"
          return JSON.parse(HTTParty.get("https://#{did[7..]}/.well_known/did.json"))
        when "plc"
          if plc_dir.nil?
            raise Error::DidPlcDirectoryRequired.new(did, (return_hook || :get_did_doc))
          end
          return JSON.parse(HTTParty.get("https://#{plc_dir}/#{did}"))
        end      
      raise Error::RepoNotFound, "Could not find PDS for #{did}"
    end
  end
end
