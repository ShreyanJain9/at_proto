# typed: true
module ATProto
  extend T::Sig

  class Writes < T::Struct
    class Write < T::Struct
      # There are three different repo options that you can perform in a commit:
      # - Create
      # - Update
      # - Delete
      # This enum provides a strongly-typed way to describe them.
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
          "$type": "com.atproto.repo.applyWrites##{self.action.serialize}",
          action: self.action.serialize,
          value: self.value || nil,
          collection: self.collection,
          rkey: self.rkey || nil,
        }.compact
      end

      # If you want to use with individual actions instead of applyWrites:
      #
      # This method returns the name of the endpoint you use to perform the repo operation.
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

      # If you want to use with individual actions instead of applyWrites:
      #
      # This method returns the POST request body you use to perform the repo operation.
      def to_individual_hash(session)
        case self.action
        when Action::Create, Action::Update
          {
            repo: session.did,
            collection: self.collection.to_s,
            record: self.value,
            rkey: rkey,
          }.compact
        when Action::Delete
          {
            repo: session.did,
            collection: self.collection.to_s,
            rkey: self.rkey,
          }.compact
        end
      end

      sig { returns(T.proc.params(session: ATProto::Session).returns(T.any(T.nilable(Integer), ATProto::Record::StrongRef))) }
      # This turns a Write into a proc that can be used to perform the repo operation, when passed a session argument.

      def to_proc
        ->session {
          session.xrpc.post.send(self.endpoint_name, **self.to_individual_hash(session)).then do |response|
            case response
            when Integer
              response
            when Hash
              ATProto::Record::StrongRef.new(
                uri: AtUri(response["uri"]),
                cid: Skyfall::CID.from_json(response["cid"]),
              )
            else
              raise ATProto::Error, "Something went wrong: #{response}"
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
    Writes.new(writes: Writes::Collector.new.instance_eval(&block).instance_eval { @writes }, session: session)
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
        @writes << Write.new(
          **({
            action: Write::Action::Create,
            value: hash,
            collection: hash["$type"] || hash[:"$type"],
            rkey: rkey&.to_s, # rkey is optional but should be a TID
          }.compact),
        )
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
