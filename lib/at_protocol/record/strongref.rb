# typed: true
module ATProto
  class Record
    class StrongRef < T::Struct
      include RequestUtils
      extend T::Sig
      const :uri, ATProto::AtUri
      const :cid, Skyfall::CID

      def to_json = {
          "uri" => uri.to_s,
          "cid" => cid.to_s,
        }

      def inspect = JSON(self.to_json)
    end
  end
end
