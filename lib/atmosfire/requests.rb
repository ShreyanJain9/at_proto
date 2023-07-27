# typed: true
module Atmosfire
  class Error < StandardError; end

  class HTTPError < Error; end

  class UnauthorizedError < HTTPError; end

  module RequestUtils # Goal is to replace with pure XRPC eventually
    extend T::Sig

    def resolve_handle(username, pds = "https://bsky.social")
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

    def create_session_uri(pds)
      "#{pds}/xrpc/com.atproto.server.createSession"
    end

    def delete_session_uri(pds)
      "#{pds}/xrpc/com.atproto.server.deleteSession"
    end

    def refresh_session_uri(pds)
      "#{pds}/xrpc/com.atproto.server.refreshSession"
    end

    def get_session_uri(pds)
      "#{pds}/xrpc/com.atproto.server.getSession"
    end

    def delete_record_uri(pds)
      "#{pds}/xrpc/com.atproto.repo.deleteRecord"
    end

    def mute_actor_uri(pds)
      "#{pds}/xrpc/app.bsky.graph.muteActor"
    end

    def upload_blob_uri(pds)
      "#{pds}/xrpc/com.atproto.repo.uploadBlob"
    end

    def get_post_thread_uri(pds, query)
      "#{pds}/xrpc/app.bsky.feed.getPostThread#{query_obj_to_query_params(query)}"
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

    sig {
      params(
        session: T.any(Atmosfire::Session, Atmosfire::Repo),
        method: String,
        key: String,
        params: Hash,
        cursor: T.nilable(
          String
        ),
        map_block: T.nilable(Proc),
      )
        .returns(T
          .nilable(
            Array
          ))
    }

    def get_paginated_data(session, method, key:, params:, cursor: nil, &map_block)
      (send_data = (params.merge({ :limit => 100, :cursor => cursor })))
      response = session.xrpc.get.public_send(method, **send_data)
      data = response.dig(key)

      if data.nil? || data.empty?
        return []
      end

      results = block_given? ? data.map(&map_block) : data
      next_cursor = T.let(response.dig("cursor"), T.nilable(String))

      if next_cursor.nil?
        return results
      else
        return results + get_paginated_data(session, method, key: key, params: params, cursor: next_cursor, &map_block)
      end
    end
  end
end
