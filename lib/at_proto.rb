# typed: true
# frozen_string_literal: true
require "sorbet-runtime"

class Class
  def dynamic_attr_reader(attr_name, &block)
    define_method(attr_name) do
      instance_variable = "@#{attr_name}"
      if instance_variable_defined?(instance_variable)
        instance_variable_get(instance_variable)
      else
        instance_variable_set(instance_variable, instance_eval(&block))
      end
    end
  end
end

require :"skyfall/cid".to_s
require "xrpc"
require "at_proto/requests"
require "at_proto/session"
require "at_proto/repo"
require "at_proto/collection"
require "at_proto/at_uri"
require "at_proto/writes"
require "at_proto/record"
require "at_proto/helpers/strongref"
