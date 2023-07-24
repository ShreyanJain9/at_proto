# This file is autogenerated. Do not edit it by hand. Regenerate it with:
#   srb rbi gems

# typed: strict
#
# If you would like to make changes to this file, great! Please create the gem's shim here:
#
#   https://github.com/sorbet/sorbet-typed/new/master?filename=lib/rubocop-performance/all/rubocop-performance.rbi
#
# rubocop-performance-1.16.0

module RuboCop
end
module RuboCop::Performance
end
module RuboCop::Performance::Version
  def self.document_version; end
end
module RuboCop::Performance::Inject
  def self.defaults!; end
end
module RuboCop::Cop
end
module RuboCop::Cop::RegexpMetacharacter
  def drop_end_metacharacter(regexp_string); end
  def drop_start_metacharacter(regexp_string); end
  def literal_at_end?(regexp); end
  def literal_at_end_with_backslash_z?(regex_str); end
  def literal_at_end_with_dollar?(regex_str); end
  def literal_at_start?(regexp); end
  def literal_at_start_with_backslash_a?(regex_str); end
  def literal_at_start_with_caret?(regex_str); end
  def safe_multiline?; end
end
module RuboCop::Cop::SortBlock
  def replaceable_body?(param0 = nil, param1, param2); end
  def sort_range(send, node); end
  def sort_with_block?(param0 = nil); end
  def sort_with_numblock?(param0 = nil); end
  extend RuboCop::AST::NodePattern::Macros
  include RuboCop::Cop::RangeHelp
end
module RuboCop::Cop::Performance
end
class RuboCop::Cop::Performance::AncestorsInclude < RuboCop::Cop::Base
  def ancestors_include_candidate?(param0 = nil); end
  def on_send(node); end
  def range(node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::ArraySemiInfiniteRangeSlice < RuboCop::Cop::Base
  def correction(receiver, range_node); end
  def endless_range?(param0 = nil); end
  def endless_range_slice?(param0 = nil); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::BigDecimalWithNumericArgument < RuboCop::Cop::Base
  def big_decimal_with_numeric_argument?(param0 = nil); end
  def on_send(node); end
  def to_d?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::BindCall < RuboCop::Cop::Base
  def bind_with_call_method?(param0 = nil); end
  def build_call_args(call_args_node); end
  def correction_range(receiver, node); end
  def message(bind_arg, call_args); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::BlockGivenWithExplicitBlock < RuboCop::Cop::Base
  def on_send(node); end
  def reassigns_block_arg?(param0 = nil, param1); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::Caller < RuboCop::Cop::Base
  def caller_with_scope_method?(param0 = nil); end
  def int_value(node); end
  def on_send(node); end
  def slow_caller?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::CaseWhenSplat < RuboCop::Cop::Base
  def autocorrect(corrector, when_node); end
  def indent_for(node); end
  def inline_fix_branch(corrector, when_node); end
  def needs_reorder?(when_node); end
  def new_branch_without_then(node, new_condition); end
  def new_condition_with_then(node, new_condition); end
  def non_splat?(condition); end
  def on_case(case_node); end
  def range(node); end
  def reorder_condition(corrector, when_node); end
  def reordering_correction(when_node); end
  def replacement(conditions); end
  def splat_offenses(when_conditions); end
  def when_branch_range(when_node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::Alignment
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::Casecmp < RuboCop::Cop::Base
  def autocorrect(corrector, node, replacement); end
  def build_good_method(method, arg, variable); end
  def downcase_downcase(param0 = nil); end
  def downcase_eq(param0 = nil); end
  def eq_downcase(param0 = nil); end
  def on_send(node); end
  def take_method_apart(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::CollectionLiteralInLoop < RuboCop::Cop::Base
  def check_literal?(node, method); end
  def enumerable_loop?(param0 = nil); end
  def enumerable_method?(method_name); end
  def kernel_loop?(param0 = nil); end
  def keyword_loop?(type); end
  def literal_class(node); end
  def loop?(ancestor, node); end
  def min_size; end
  def node_within_enumerable_loop?(node, ancestor); end
  def nonmutable_method_of_array_or_hash?(node, method); end
  def on_send(node); end
  def parent_is_loop?(node); end
end
class RuboCop::Cop::Performance::CompareWithBlock < RuboCop::Cop::Base
  def compare?(param0 = nil); end
  def compare_range(send, node); end
  def message(send, method, var_a, var_b, args); end
  def on_block(node); end
  def replaceable_body?(param0 = nil, param1, param2); end
  def slow_compare?(method, args_a, args_b); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::ConcurrentMonotonicTime < RuboCop::Cop::Base
  def concurrent_monotonic_time?(param0 = nil); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::ConstantRegexp < RuboCop::Cop::Base
  def include_interpolated_const?(node); end
  def on_regexp(node); end
  def regexp_escape?(param0 = nil); end
  def within_allowed_assignment?(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::Count < RuboCop::Cop::Base
  def autocorrect(corrector, node, selector_node, selector); end
  def count_candidate?(param0 = nil); end
  def eligible_node?(node); end
  def negate_block_pass_as_inline_block(node); end
  def negate_block_pass_reject(corrector, node); end
  def negate_block_reject(corrector, node); end
  def negate_expression(node); end
  def negate_reject(corrector, node); end
  def on_send(node); end
  def source_starting_at(node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::DeletePrefix < RuboCop::Cop::Base
  def delete_prefix_candidate?(param0 = nil); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RegexpMetacharacter
end
class RuboCop::Cop::Performance::DeleteSuffix < RuboCop::Cop::Base
  def delete_suffix_candidate?(param0 = nil); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RegexpMetacharacter
end
class RuboCop::Cop::Performance::Detect < RuboCop::Cop::Base
  def accept_first_call?(receiver, body); end
  def autocorrect(corrector, node, replacement); end
  def detect_candidate?(param0 = nil); end
  def lazy?(node); end
  def message_for_method(method, index); end
  def on_send(node); end
  def preferred_method; end
  def register_offense(node, receiver, second_method, index); end
  def replacement(method, index); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::DoubleStartEndWith < RuboCop::Cop::Base
  def autocorrect(corrector, first_call_args, second_call_args, combined_args); end
  def check_for_active_support_aliases?; end
  def check_with_active_support_aliases(param0 = nil); end
  def combine_args(first_call_args, second_call_args); end
  def message(node, receiver, method, combined_args); end
  def on_or(node); end
  def process_source(node); end
  def two_start_end_with_calls(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::EndWith < RuboCop::Cop::Base
  def on_match_with_lvasgn(node); end
  def on_send(node); end
  def redundant_regex?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RegexpMetacharacter
end
class RuboCop::Cop::Performance::FixedSize < RuboCop::Cop::Base
  def allowed_argument?(arg); end
  def allowed_parent?(node); end
  def allowed_variable?(var); end
  def contains_double_splat?(node); end
  def contains_splat?(node); end
  def counter(param0 = nil); end
  def non_string_argument?(node); end
  def on_send(node); end
end
class RuboCop::Cop::Performance::FlatMap < RuboCop::Cop::Base
  def autocorrect(corrector, node); end
  def flat_map_candidate?(param0 = nil); end
  def offense_for_levels(node, map_node, first_method, flatten); end
  def offense_for_method(node, map_node, first_method, flatten); end
  def on_send(node); end
  def register_offense(node, map_node, first_method, flatten, message); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::InefficientHashSearch < RuboCop::Cop::Base
  def autocorrect_argument(node); end
  def autocorrect_hash_expression(node); end
  def autocorrect_method(node); end
  def current_method(node); end
  def inefficient_include?(param0 = nil); end
  def message(node); end
  def on_send(node); end
  def use_long_method; end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::MapCompact < RuboCop::Cop::Base
  def compact_method_with_final_newline_range(compact_method_range); end
  def invoke_method_after_map_compact_on_same_line?(compact_node, chained_method); end
  def map_compact(param0 = nil); end
  def map_method_and_compact_method_on_same_line?(map_node, compact_node); end
  def on_send(node); end
  def remove_compact_method(corrector, map_node, compact_node, chained_method); end
  def use_dot?(node); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::MethodObjectAsBlock < RuboCop::Cop::Base
  def method_object_as_argument?(param0 = nil); end
  def on_block_pass(node); end
end
class RuboCop::Cop::Performance::OpenStruct < RuboCop::Cop::Base
  def on_send(node); end
  def open_struct(param0 = nil); end
end
class RuboCop::Cop::Performance::RangeInclude < RuboCop::Cop::Base
  def on_send(node); end
  def range_include(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::IoReadlines < RuboCop::Cop::Base
  def autocorrect(corrector, enumerable_call, readlines_call, receiver); end
  def build_bad_method(enumerable_call); end
  def build_call_args(call_args_node); end
  def build_good_method(enumerable_call); end
  def correction_range(enumerable_call, readlines_call); end
  def offense_range(enumerable_call, readlines_call); end
  def on_send(node); end
  def readlines_on_class?(param0 = nil); end
  def readlines_on_instance?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::RedundantBlockCall < RuboCop::Cop::Base
  def args_include_block_pass?(blockcall); end
  def autocorrect(corrector, node); end
  def blockarg_assigned?(param0, param1); end
  def blockarg_calls(param0, param1); end
  def blockarg_def(param0 = nil); end
  def calls_to_report(argname, body); end
  def on_def(node); end
  def on_defs(node); end
  def shadowed_block_argument?(body, block_argument_of_method_signature); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::RedundantEqualityComparisonBlock < RuboCop::Cop::Base
  def new_argument(block_argument, block_body); end
  def offense_range(node); end
  def on_block(node); end
  def one_block_argument?(block_arguments); end
  def same_block_argument_and_is_a_argument?(block_body, block_argument); end
  def use_block_argument_in_method_argument_of_operand?(block_argument, operand); end
  def use_equality_comparison_block?(block_body); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
end
class RuboCop::Cop::Performance::RedundantMatch < RuboCop::Cop::Base
  def autocorrect(corrector, node); end
  def autocorrectable?(node); end
  def match_call?(param0 = nil); end
  def on_send(node); end
  def only_truthiness_matters?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::RedundantMerge < RuboCop::Cop::Base
  def correct_multiple_elements(corrector, node, parent, new_source); end
  def correct_single_element(corrector, node, new_source); end
  def each_redundant_merge(node); end
  def kwsplat_used?(pairs); end
  def leading_spaces(node); end
  def max_key_value_pairs; end
  def message(node); end
  def modifier_flow_control?(param0 = nil); end
  def non_redundant_merge?(node, receiver, pairs); end
  def non_redundant_pairs?(receiver, pairs); end
  def non_redundant_value_used?(receiver, node); end
  def on_send(node); end
  def redundant_merge_candidate(param0 = nil); end
  def rewrite_with_modifier(node, parent, new_source); end
  def to_assignments(receiver, pairs); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::Alignment
end
class RuboCop::Cop::Performance::RedundantMerge::EachWithObjectInspector
  def each_with_object_node(param0 = nil); end
  def eligible_receiver?; end
  def initialize(node, receiver); end
  def node; end
  def receiver; end
  def second_argument; end
  def unwind(receiver); end
  def value_used?; end
  extend RuboCop::AST::NodePattern::Macros
end
class RuboCop::Cop::Performance::RedundantSortBlock < RuboCop::Cop::Base
  def on_block(node); end
  def on_numblock(node); end
  def register_offense(send, node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::SortBlock
end
class RuboCop::Cop::Performance::RedundantSplitRegexpArgument < RuboCop::Cop::Base
  def determinist_regexp?(regexp_node); end
  def on_send(node); end
  def replacement(regexp_node); end
  def split_call_with_regexp?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::RedundantStringChars < RuboCop::Cop::Base
  def build_bad_method(method, args); end
  def build_call_args(call_args_node); end
  def build_good_method(method, args); end
  def build_good_method_for_brackets_or_first_method(method, args); end
  def build_message(method, args); end
  def correction_range(receiver, node); end
  def offense_range(receiver, node); end
  def on_send(node); end
  def redundant_chars_call?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::RegexpMatch < RuboCop::Cop::Base
  def autocorrect(corrector, node); end
  def check_condition(cond); end
  def correct_operator(corrector, recv, arg, oper = nil); end
  def correction_range(recv, arg); end
  def find_last_match(body, range, scope_root); end
  def last_match_used?(match_node); end
  def last_matches(param0); end
  def match_gvar?(sym); end
  def match_method?(param0 = nil); end
  def match_node?(param0 = nil); end
  def match_operator?(param0 = nil); end
  def match_threequals?(param0 = nil); end
  def match_with_int_arg_method?(param0 = nil); end
  def match_with_lvasgn?(node); end
  def message(node); end
  def modifier_form?(match_node); end
  def next_match_pos(body, match_node_pos, scope_root); end
  def on_case(node); end
  def on_if(node); end
  def range_to_search_for_last_matches(match_node, body, scope_root); end
  def replace_with_match_predicate_method(corrector, recv, arg, op_range); end
  def scope_body(node); end
  def scope_root(node); end
  def search_match_nodes(param0); end
  def swap_receiver_and_arg(corrector, recv, arg); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
end
class RuboCop::Cop::Performance::ReverseEach < RuboCop::Cop::Base
  def offense_range(node); end
  def on_send(node); end
  def reverse_each?(param0 = nil); end
  def use_return_value?(node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::ReverseFirst < RuboCop::Cop::Base
  def build_bad_method(node); end
  def build_good_method(node); end
  def build_message(node); end
  def correction_range(receiver, node); end
  def on_send(node); end
  def reverse_first_candidate?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::SelectMap < RuboCop::Cop::Base
  def bad_method?(param0 = nil); end
  def map_method_candidate(node); end
  def offense_range(node, map_method); end
  def on_send(node); end
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::Size < RuboCop::Cop::Base
  def array?(param0 = nil); end
  def count?(param0 = nil); end
  def hash?(param0 = nil); end
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::SortReverse < RuboCop::Cop::Base
  def on_block(node); end
  def on_numblock(node); end
  def register_offense(send, node); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::SortBlock
end
class RuboCop::Cop::Performance::Squeeze < RuboCop::Cop::Base
  def on_send(node); end
  def repeating_literal?(regex_str); end
  def squeeze_candidate?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::StartWith < RuboCop::Cop::Base
  def on_match_with_lvasgn(node); end
  def on_send(node); end
  def redundant_regex?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RegexpMetacharacter
end
class RuboCop::Cop::Performance::StringIdentifierArgument < RuboCop::Cop::Base
  def on_send(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::StringInclude < RuboCop::Cop::Base
  def literal?(regex_str); end
  def on_match_with_lvasgn(node); end
  def on_send(node); end
  def redundant_regex?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::StringReplacement < RuboCop::Cop::Base
  def accept_first_param?(first_param); end
  def accept_second_param?(second_param); end
  def autocorrect(corrector, node); end
  def first_source(first_param); end
  def message(node, first_source, second_source); end
  def method_suffix(node); end
  def offense(node, first_param, second_param); end
  def on_send(node); end
  def range(node); end
  def remove_second_param(corrector, node, first_param); end
  def replace_method(corrector, node, first_source, second_source, first_param); end
  def replacement_method(node, first_source, second_source); end
  def source_from_regex_constructor(node); end
  def source_from_regex_literal(node); end
  def string_replacement?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::Sum < RuboCop::Cop::Base
  def acc_plus_elem?(param0 = nil, param1, param2); end
  def array_literal?(node); end
  def autocorrect(corrector, init, range); end
  def autocorrect_sum_map(corrector, sum, map, init); end
  def build_block_bad_method(method, init, var_acc, var_elem, body); end
  def build_block_message(send, init, var_acc, var_elem, body); end
  def build_good_method(init, block_pass = nil); end
  def build_method_bad_method(init, method, operation); end
  def build_method_message(node, method, init, operation); end
  def build_sum_map_message(method, init); end
  def elem_plus_acc?(param0 = nil, param1, param2); end
  def empty_array_literal?(node); end
  def handle_sum_candidate(node); end
  def handle_sum_map_candidate(node); end
  def method_call_with_args_range(node); end
  def on_block(node); end
  def on_send(node); end
  def sum_block_range(send, node); end
  def sum_candidate?(param0 = nil); end
  def sum_map_candidate?(param0 = nil); end
  def sum_map_range(map, sum); end
  def sum_method_range(node); end
  def sum_with_block_candidate?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
  extend RuboCop::Cop::TargetRubyVersion
  include RuboCop::Cop::RangeHelp
end
class RuboCop::Cop::Performance::TimesMap < RuboCop::Cop::Base
  def check(node); end
  def message(map_or_collect, count); end
  def on_block(node); end
  def on_numblock(node); end
  def on_send(node); end
  def times_map_call(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::UnfreezeString < RuboCop::Cop::Base
  def dup_string?(param0 = nil); end
  def on_send(node); end
  def string_new?(param0 = nil); end
  def string_value(node); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::UriDefaultParser < RuboCop::Cop::Base
  def on_send(node); end
  def uri_parser_new?(param0 = nil); end
  extend RuboCop::Cop::AutoCorrector
end
class RuboCop::Cop::Performance::ChainArrayAllocation < RuboCop::Cop::Base
  def chain_array_allocation?(param0 = nil); end
  def on_send(node); end
  include RuboCop::Cop::RangeHelp
end
