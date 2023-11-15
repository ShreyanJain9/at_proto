# typed: true

module ATProto
  Credentials = Struct.new :username, :pw, :pds

  class Session < T::Struct
    include RequestUtils
    extend T::Sig
    attr_reader :xrpc
    prop :access_token, String
    prop :refresh_token, String
    prop :pds, String
    def self.from_credentials(username, pw, pds)
      xrpc = XRPC::Client.new(pds)
      xrpc.post.com_atproto_server_createSession(
        username: username,
        password: pw,
      ).then do |session|
        xrpc.token = session["accessToken"]
        new(
          access_token: session["accessToken"],
          refresh_token: session["refreshToken"],
          pds: pds,
        ).tap { |s| s.instance_eval { @xrpc = xrpc } }
      end
    end

    def refresh!
      XRPC::Client.new(pds, token: refresh_token).post.com_atproto_server_refreshSession.then do |session|
        self.access_token = session["accessToken"]
        self.refresh_token = session["refreshToken"]
      end
    end

    def delete!
      XRPC::Client.new(pds, token: refresh_token).post.com_atproto_server_deleteSession
    end
  end
end
