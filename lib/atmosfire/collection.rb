# typed: strict
module Atmosfire
  class Repo
    class Collection < T::Struct
      include RequestUtils
      extend T::Sig

      const(:repo, Atmosfire::Repo)
      const(:collection, String)

      sig { params(limit: Integer).returns(T::Array[Atmosfire::Record]) }

      def list(limit = 10)
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

      def to_uri
        "at://#{self.repo.did}/#{self.collection}"
      end

      sig { returns(String) }

      def to_s
        @collection
      end

      sig { params(rkey: String).returns(T.nilable(Atmosfire::Record)) }

      def [](rkey)
        Atmosfire::Record.from_uri(
          T.must(
            at_uri(
              "at://#{self.repo.did}/#{@collection}/#{rkey}"
            )
          ),
          self.repo.pds
        )
      end
    end
  end
end
