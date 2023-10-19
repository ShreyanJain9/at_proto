# typed: true
module ATProto
  class Repo
    class Collection < T::Struct
      include RequestUtils
      include Enumerable
      extend T::Sig

      const(:repo, ATProto::Repo)
      const(:collection, String)

      sig { params(count: T.nilable(Integer)).returns(T::Array[ATProto::Record]) }

      def list(count = nil)
        (get_paginated_data_lazy(
          self.repo,
          :com_atproto_repo_listRecords.to_s,
          key: "records",
          params: { repo: self.repo.to_s, collection: collection },
        ) do |record|
          ATProto::Record.from_hash(record)
        end).first(count)
      end

      sig { returns(String) }

      def to_uri = "at://#{self.repo.did}/#{self.collection}/"

      alias_method :to_s, :to_uri
      sig { params(rkey: String).returns(T.nilable(ATProto::Record)) }

      def [](rkey)
        ATProto::Record.from_uri(
          T.must(
            at_uri(
              "at://#{self.repo.did}/#{@collection}/#{rkey}"
            )
          ),
          self.repo.pds
        )
      end

      def each(&block)
        if block_given?
          list_all.each(&block)
        else
          list_all
        end
      end
    end
  end
end
