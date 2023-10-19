# typed: true
module ATProto
  class Error < StandardError; end

  class HTTPError < Error; end

  class UnauthorizedError < HTTPError; end

  module RequestUtils # Goal is to replace with pure XRPC eventually
    extend T::Sig

    def resolve_handle(username, pds)
      (XRPC::Client.new(pds).get.com_atproto_identity_resolveHandle(handle: username))["did"]
    end

    def query_obj_to_query_params(q)
      out = "?"
      q.to_h.each do |key, value|
        out += "#{key}=#{value}&" unless value.nil? || (value.class.method_defined?(:empty?) && value.empty?)
      end
      out.slice(0...-1)
    end

    def default_headers
      { "Content-Type" => "application/json" }
    end

    def default_authenticated_headers(session)
      default_headers.merge({
        Authorization: "Bearer #{session.access_token}",
      })
    end

    def refresh_token_headers(session)
      default_headers.merge({
        Authorization: "Bearer #{session.refresh_token}",
      })
    end

    def get_paginated_data(session, method, key:, params:, cursor: nil, count:, &map_block)
      get_paginated_data_lazy(session, method, key: key, params: params, cursor: cursor, &map_block).first(count)
    end

    # Generates a lazy enumerator for paginated data retrieval.
    #
    # Parameters:
    # - session: The session object used for making API requests.
    # - method: The name of the method to be called on the session object.
    # - key: The key to access the data in the response object.
    # - params: Additional parameters to be passed in the API request.
    # - cursor: The cursor for pagination. Defaults to nil.
    # - count: The maximum number of results to retrieve. Defaults to nil.
    # - &map_block: An optional block to transform each result.
    #
    # Returns:
    # - A +Enumerator::Lazy+ that yields paginated data.
    def get_paginated_data_lazy(session, method, key:, params:, cursor: nil, &map_block)
      Enumerator.new do |yielder|
        loop do
          send_data = params.merge(limit: 100, cursor: cursor)
          response = session.xrpc.get.public_send(method, **send_data)
          data = response.dig(key)

          break if data.nil? || data.empty?

          results = map_block ? data.map(&map_block) : data
          results.each { |result| yielder << result }

          cursor = response.dig("cursor")
          break if cursor.nil?
        end
      end.lazy
    end
  end
end

module ATProto
  module RequestUtils
    class XRPCResponseCode < T::Enum
      enums do
        Unknown = new(1)
        InvalidResponse = new(2)
        Success = new(200)
        InvalidRequest = new(400)
        AuthRequired = new(401)
        Forbidden = new(403)
        XRPCNotSupported = new(404)
        PayloadTooLarge = new(413)
        RateLimitExceeded = new(429)
        InternalServerError = new(500)
        MethodNotImplemented = new(501)
        UpstreamFailure = new(502)
        NotEnoughResouces = new(503)
        UpstreamTimeout = new(504)
      end
    end
  end
end
