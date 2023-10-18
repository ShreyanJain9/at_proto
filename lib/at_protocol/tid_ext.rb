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


class << ATProto::TID
  # For use in case statements, so you can see if a string is a valid TID
  def str?
    o = Object.new
    def o.===(str)
        ATProto::TID.from_string(str).to_s == str
    end
    o
  end
end
