# typed: false
module ATProto
  module DID
    class Document
      extend T::Sig
      attr_reader :context, :id, :alsoKnownAs, :verificationMethod, :service

      sig { params(json_doc: String).void }

      def initialize(json_doc)
        data = JSON.parse(json_doc)
        @context = data["@context"]
        @id = data["id"].to_sym
        @alsoKnownAs = (data["alsoKnownAs"].map { |aka| aka.to_sym })[0]
        @verificationMethod = (data["verificationMethod"].map { |vm| VerificationMethod.new(vm) })[0]
        @service = (data["service"].map { |srv| Service.new(srv) })[0]
      end
    end

    class VerificationMethod
      extend T::Sig
      attr_reader :id, :type, :controller, :publicKeyMultibase

      sig { params(data: Hash).void }

      def initialize(data)
        @id = data["id"].to_sym
        @type = data["type"].to_sym
        @controller = data["controller"].to_sym
        @publicKeyMultibase = data["publicKeyMultibase"].to_sym
      end
    end

    class Service
      attr_accessor :id, :type, :serviceEndpoint

      def initialize(data)
        @id = data["id"].to_sym
        @type = data["type"].to_sym
        @serviceEndpoint = data["serviceEndpoint"].to_sym
      end
    end

    class PLC < T::Struct
      extend T::Sig
      const :plc_dir, String, default: "plc.directory"
      const :did, String

      dynamic_attr_reader(:document) {
        ATProto::DID::Document.new(HTTParty.get("https://#{@plc_dir}/#{@did}"))
      }

      dynamic_attr_reader(:repo) { ATProto::Repo.new(@did, @pds) }
    end
  end
end
