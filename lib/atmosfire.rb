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
require "atmosfire/requests"
require "atmosfire/session"
require "atmosfire/repo"
require "atmosfire/collection"
require "atmosfire/at_uri"
require "atmosfire/record"
require "atmosfire/helpers/strongref"
