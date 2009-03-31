#!/usr/local/bin/ruby
# Author: Ilya Grigorik (www.igvita.com)

require "rubygems"
require "parse_tree"
require "parse_tree_extensions"
require "unified_ruby"

class Ruby2Lolz < SexpProcessor

  def self.translate(klass_or_str, method = nil)
    sexp = ParseTree.translate(klass_or_str, method)

    # unified_ruby is a rewriter plugin that rewires
    # the parse tree to make it easier to work with
    #  - defn arg above scope / making it arglist / ...
    unifier = Unifier.new
    unifier.processors.each do |p|
      p.unsupported.delete :cfunc # HACK
    end
    sexp = unifier.process(sexp)

    self.new.process(sexp)
  end

  def initialize
    super
    @indent = "  "
    
    self.auto_shift_type = true
    self.strict = true
    self.expected = String
  end

  ############################################################
  # Processors

  def process_lit(exp);   exp.shift.to_s;     end
  def process_str(exp);   exp.shift.to_s;     end
  def process_scope(exp); process(exp.shift); end
  def process_lvar(exp);  exp.shift.to_s;     end


  def process_arglist(exp, verbose = false)
    code = []
    until exp.empty? do
      if verbose
        code.push indent("AWSUM VAR\n #{indent(process(exp.shift))}\nKTHNX.")
      else
        code.push process(exp.shift)
      end
    end
    code.join("\n")
  end

  def process_array(exp)
    str = "I CAN MANY HAZ\n"
    str << indent(process_arglist(exp, true))
    str << "\nKTHNXBYE."
  end

  def process_hash(exp)
    result = []

    until exp.empty?
      lhs = process(exp.shift)
      rhs = exp.shift
      t = rhs.first
      rhs = process rhs
      rhs = "#{rhs}" unless [:lit, :str].include? t # TODO: verify better!

      result.push indent("I CAN HAS #{lhs.to_s.capitalize}\n #{indent(rhs)}\nKTHNX.")
    end

    case self.context[1]
    when :arglist, :argscat then
      return "#{result.join(', ')}"
    else
      return "OH HAI\n#{result.join("\n")}\nKTHNXBYE."
    end
  end

  def process_defn(exp)
    type1 = exp[1].first
    type2 = exp[2].first rescue nil

    case type1
    when :scope, :args then
      name = exp.shift
      args = process(exp.shift)
      args = "" if args == "[]"
      body = indent(process(exp.shift))
      return "HOW DUZ I HAZ #{name} [#{args}]\n#{body}\nIF U SAY SO"
    else
      raise "Unknown defn type: #{type1} for #{exp.inspect}"
    end   
  end

  def process_call(exp)
    receiver_node_type = exp.first.nil? ? nil : exp.first.first
    receiver = process exp.shift

    name = exp.shift
    args_exp = exp.shift rescue nil
    if args_exp && args_exp.first == :array # FIX
      args = "#{process(args_exp)[1..-2]}"
    else
      args = process args_exp
      args = nil if args.empty?
    end

    case name
    when :<=>, :==, :<, :>, :<=, :>=, :-, :+, :*, :/, :%, :<<, :>>, :** then
      "(#{receiver} #{name} #{args})"
    when :[] then
      "#{receiver}[#{args}]"
    when :"-@" then
      "-#{receiver}"
    when :"+@" then
      "+#{receiver}"
    else
      unless receiver.nil? then
        "#{receiver}.#{name}#{args ? "#{args})" : args}"
      else
        "#{name}#{args ? " #{args}" : args}"
      end
    end
  end

  def process_args(exp)
    args = []

    until exp.empty? do
      arg = exp.shift
      case arg
      when Symbol then
        args << "YR #{arg}"
      when Array then
        case arg.first
        when :block then
          asgns = {}
          arg[1..-1].each do |lasgn|
            asgns[lasgn[1]] = process(lasgn)
          end

          args.each_with_index do |name, index|
            args[index] = asgns[name] if asgns.has_key? name
          end
        else
          raise "unknown arg type #{arg.first.inspect}"
        end
      else
        raise "unknown arg type #{arg.inspect}"
      end
    end

    return "#{args.join ', '}"
  end

  def process_block(exp)
    result = []
    exp << nil if exp.empty?
    until exp.empty? do
      code = exp.shift

      if code.nil? or code.first == :nil then
        result << "# do nothing"
      else
        result << process(code)
      end
    end

    result = result.join "\n"
    result = case self.context[1]
    when nil, :scope, :if, :iter, :resbody, :when, :while then
      result + "\n"
    else
      "(#{result})"
    end

    return result
  end

  def indent(s)
    s.to_s.split(/\n/).map{|line| @indent + line}.join("\n")
  end
end
