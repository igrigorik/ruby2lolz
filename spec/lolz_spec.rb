# LOLZ SPECS v1.2, KTHNXBAI.
#
# - http://lolcode.com/specs/1.2
#

require "rubygems"
require "parse_tree"
require "parse_tree_extensions"
require "spec"
require "ruby2lolz"

def read_spec(name); File.open("spec/specs/#{name}.txt", "r").read.gsub("\r", ""); end

describe Ruby2Lolz do

  it "should translate Ruby hash to lolz, kthnx" do
    h = {:user => "Ilya"}.inspect
    Ruby2Lolz.translate(h).should == read_spec("hash")
  end
  
  it "should translate Ruby hash to lolz, kthnx" do
    {:user => "Ilya"}.to_lolz.should == read_spec("hash")
  end

  it "should translate Ruby array to lolz, kthnx" do
    a = ["igrigorik", "ig"].inspect
    Ruby2Lolz.translate(a).should == read_spec("array")
  end
  
  it "should translate Ruby array to lolz, kthnx" do
    ["igrigorik", "ig"].to_lolz.should == read_spec("array")
  end

  it "should translate mixed Ruby array/hash to lolz, kthnx" do
    h = {:nickname => ["igrigorik", "ig"]}.inspect
    Ruby2Lolz.translate(h).should == read_spec("hash_array")
  end
  
  it "should translate mixed Ruby array/hash to lolz, kthnx" do
    {:nickname => ["igrigorik", "ig"]}.to_lolz.should == read_spec("hash_array")
  end
  
  it "should translate Ruby method to lolz, kthnx" do
    # [:defn,
    #  :hello,
    #  [:scope, [:block, [:args, :str], [:fcall, :puts, [:array, [:lvar, :str]]]]]]
    class Simple
      def hello(str); puts str; end;
    end

    Ruby2Lolz.translate(Simple, :hello).should == read_spec("method")
  end

  #  it "should translate Ruby block to lolz, kthnx" do
  #    b = Proc.new {|var| puts var }.to_ruby
  #    puts Ruby2Lolz.translate(b)
  #    Ruby2Lolz.translate(b).should == read_spec("block")
  #  end
end
