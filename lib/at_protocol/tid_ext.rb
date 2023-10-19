require "at_protocol/tid"

class Time
  extend T::Sig
  sig { returns(ATProto::TID) }

  def to_tid
    ATProto::TID.new(self)
  end
end

class String
  extend T::Sig
  sig { returns(ATProto::TID) }

  def to_tid
    ATProto::TID.from_string(self)
  end
end

class ATProto::TID
  extend T::Sig
  sig { returns(String) }

  def inspect
    "#<ATProto::TID(#{self.to_s})>"
  end

  include Comparable

  sig { params(other: ATProto::TID).returns(Integer) }

  def <=>(other)
    [to_time, clock_id] <=> [other.to_time, other.clock_id]
  end

  sig { returns(ATProto::TID) }

  def succ
    ATProto::TID.new(self.to_time + 1)
  end
end

class << ATProto::TID
  # For use in case statements, so you can see if a string is a valid TID
  # @return [Boolean, Object]
  def str?(s = nil)
    return true if s&.to_tid&.to_s == s
    o = Object.new
    def o.===(str)
      ATProto::TID.from_string(str).to_s == str
    end
    o
  end
end
