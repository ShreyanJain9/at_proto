# typed: true
module Atmosfire
  class Record
    class StrongRef < T::Struct
      include RequestUtils
      extend T::Sig
      const :uri, Atmosfire::AtUri
      prop :cid, Skyfall::CID

      def to_json
        {
          "uri" => uri.to_s,
          "cid" => cid.to_s,
        }
      end

      def inspect
        self.to_json.to_json
      end
    end
  end
end
