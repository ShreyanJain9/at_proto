# typed: true
module ATProto
  extend T::Sig

  class Writes < T::Struct
    class Write < T::Struct
      class Action < T::Enum
        enums do
          Create = new(:create)
          Update = new(:update)
          Delete = new(:delete)
        end
      end

      extend T::Sig
      prop(:action, Action)
      prop(:value, T.nilable(Hash))
      prop(:collection, String)
      prop(:rkey, T.nilable(String))

      sig { returns(T::Hash[Symbol, T.any(String, Symbol, Hash)]) }

      def to_h
        {
          :"$type" => "com.atproto.repo.applyWrites##{self.action.serialize}",
          action: self.action.serialize,
          value: self.value || nil,
          collection: self.collection,
          rkey: self.rkey || nil,
        }.compact
      end

      # If you want to use with individual actions instead of applyWrites:
      def endpoint_name(real_xrpc = false)
        case self.action
        when Action::Create
          "com.atproto.repo.createRecord"
        when Action::Update
          "com.atproto.repo.putRecord"
        when Action::Delete
          "com.atproto.repo.deleteRecord"
        end
          .gsub(".", "_") unless real_xrpc
      end

      def to_individual_hash(session)
        case self.action
        when Action::Create
          {
            repo: session.did,
            collection: self.collection.to_s,
            record: self.value,
            rkey: self.rkey || nil,
          }.compact
        when Action::Update
          {
            repo: session.did,
            collection: self.collection.to_s,
            rkey: self.rkey,
            record: self.value,
          }.compact
        when Action::Delete
          {
            repo: session.did,
            collection: self.collection.to_s,
            rkey: self.rkey,
          }.compact
        end
      end

      def to_proc
        ->session {
          session.xrpc.post.send(self.endpoint_name, **self.to_individual_hash(session)).then do |response|
            if response.is_a?(Numeric)
              response
            elsif response.is_a?(Hash)
              ATProto::Record::StrongRef.new(
                uri: RequestUtils.at_uri(response["uri"]),
                cid: Skyfall::CID.from_json(response["cid"]),
              )
            end
          end
        }
      end
    end

    extend T::Sig
    prop(:writes, T::Array[Write])
    prop(:session, ATProto::Session)

    sig { returns(Hash) }

    def to_h
      {
        writes: self.writes.map(&:to_h).compact,
        repo: self.session.did,
      }.compact
    end

    def apply
      self.session.xrpc.post.com_atproto_repo_applyWrites(**to_h)
    end

    class << self
      extend T::Sig
    end
  end

  def self.Writes(session, &block)
    Writes.new(writes: Writes::Collector.new.instance_eval(&block), session: session)
  end

  class Writes
    def inspect
      "#<ATProto::Writes(writes: #{writes.inspect}, session: #{session.did})>"
    end

    class Collector
      include RequestUtils
      extend T::Sig

      def initialize
        @writes = []
      end

      sig { params(rkey: T.any(String, ATProto::TID), hash: T.untyped).returns(T::Array[Write]) }

      def create(rkey: TID.new.to_s, **hash)
        @writes << Write.new(**({
                               action: Write::Action::Create,
                               value: hash,
                               collection: hash["$type"] || hash[:"$type"],
                               rkey: rkey&.to_s, # rkey is optional but should be a TID
                             }.compact))
      end

      sig { params(uri: T.any(String, ATProto::AtUri), hash: Hash).returns(T::Array[Write]) }

      def update(uri, **hash)
        aturi = at_uri(uri)
        @writes << Write.new(
          action: Write::Action::Update,
          value: hash,
          collection: T.must(aturi)&.collection&.to_s,
          rkey: T.must(aturi)&.rkey,
        )
      end

      sig { params(uri: T.any(String, ATProto::AtUri)).returns(T::Array[Write]) }

      def delete(uri)
        aturi = at_uri(uri)
        @writes << Write.new(
          action: Write::Action::Delete,
          collection: T.must(aturi).collection.to_s,
          rkey: T.must(aturi).rkey,
        )
      end
    end
  end
end
