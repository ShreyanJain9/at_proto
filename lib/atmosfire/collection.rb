# typed: true
module Atmosfire
  class Repo
    Collection = Struct.new :repo, :collection do
      extend T::Sig

      sig { params(repo: Atmosfire::Repo, lexicon_name: String).void }

      def initialize(repo, lexicon_name)
        super(repo, lexicon_name)
      end

      sig { params(limit: Integer).returns(T::Array[Atmosfire::Record]) }

      def list_records(limit = 10)
        self.repo.pds_endpoint
          .get.com_atproto_repo_listRecords(
            repo: self.repo.did,
            collection: self.collection,
            limit: limit,
          )["records"]
          .map { |record|
          Atmosfire::Record.from_hash(record)
        }
      end

      sig { returns(String) }

      def to_s
        "at://#{self.repo.did}/#{self.collection}"
      end

      # sig { params(rkey: String).returns(Atmosfire::Record) }

      def [](rkey)
        Atmosfire::Record.from_uri("at://#{self.repo.did}/#{@collection}/#{rkey}", self.repo.pds)
      end
    end
  end
end
