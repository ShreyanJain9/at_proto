# typed: true
module ATProto
  class Repo
    class Collection < T::Struct
      include RequestUtils
      include Enumerable
      extend T::Sig

      const(:repo, ATProto::Repo)
      const(:collection, String)

      def list(count = nil)
        (get_paginated_data(
          self.repo,
          "com.atproto.repo.listRecords",
          key: "records",
          params: { repo: self.repo.to_s, collection: collection },
        ) do |record|
          ATProto::Record.from_hash(record)
        end)
          .first(count) if count
      end

      sig { returns(String) }

      def to_uri = "at://#{self.repo.did}/#{self.collection}/"

      alias_method :to_s, :collection

      sig { params(rkey: String).returns(ATProto::Record) }

      def [](rkey)
        ATProto::Record.from_uri(
              ATProto::AtUri("at://#{self.repo.did}/#{@collection}/#{rkey}"), 
              self.repo.pds)
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
