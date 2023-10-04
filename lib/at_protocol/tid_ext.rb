require "at_protocol/tid"

class Time
  def to_tid
    ATProto::TID.new(self)
  end
end

class String
  def to_tid
    ATProto::TID.from_string(self)
  end
end

class ATProto::TID
  def inspect
    "#<ATProto::TID(#{self.to_s})>"
  end
end
