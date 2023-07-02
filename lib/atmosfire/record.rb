module Atmosfire
  class Record
    def initialize(json_hash)
      @uri = json_hash["uri"]
      @cid = json_hash["cid"]
      @collection = json_hash["value"]["$type"]
      @timestamp = Time.parse(json_hash["value"]["createdAt"])
      @raw_content = json_hash["value"]
    end
  end
end
