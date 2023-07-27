# typed: true

module Atmosfire
  Credentials = Struct.new :username, :pw, :pds do
    extend T::Sig

    sig { params(username: String, pw: String, pds: String).void }

    def initialize(username, pw, pds = "https://bsky.social")
      super
      self.pds ||= "https://bsky.social"
    end
  end

  class Session
    include RequestUtils
    extend T::Sig

    attr_reader :pds, :access_token, :refresh_token, :did, :xrpc

    sig { params(credentials: Atmosfire::Credentials, should_open: T::Boolean).void }

    def initialize(credentials, should_open = true)
      @credentials = credentials
      @pds = credentials.pds
      open! if should_open
    end

    def open!
      @xrpc = XRPC::Client.new(@pds)
      response = @xrpc.post.com_atproto_server_createSession(identifier: @credentials.username, password: @credentials.pw)

      raise UnauthorizedError if response["accessJwt"].nil?

      @access_token = response["accessJwt"]
      @refresh_token = response["refreshJwt"]
      @did = response["did"]

      @xrpc = XRPC::Client.new(@pds, @access_token)
      @refresher = XRPC::Client.new(@pds, @refresh_token)
    end

    def refresh!
      response = @refresher.post.com_atproto_server_refreshSession
      raise UnauthorizedError if response["accessJwt"].nil?
      @access_token = response["accessJwt"]
      @refresh_token = response["refreshJwt"]
      @xrpc = XRPC::Client.new(@pds, @access_token)
      @refresher = XRPC::Client.new(@pds, @refresh_token)
    end

    sig { returns(T.nilable(Hash)) }

    def get_session
      @xrpc.get.com_atproto_server_getSession
    end

    def delete!
      response = HTTParty.post(
        URI(delete_session_uri(pds)),
        headers: refresh_token_headers(self),
      )
      if response.code == 200
        { success: true }
      else
        raise UnauthorizedError
      end
    end
  end
end

module Atmosfire
  class TokenSession < Session
    extend T::Sig

    sig { params(token: String, pds: String).void }

    def initialize(token, pds = "https://bsky.social")
      @token = token
      @pds = pds
      open!
    end

    def open!
      @xrpc = XRPC::Client.new(@pds, @token)
    end
  end
end
