class Node

  include Comparable

  attr_accessor :data, :left_child, :right_child

  def initialize(data, left_child=nil, right_child=nil)
    @data = data
    @left_child = left_child
    @right_child = right_child
  end

  # include comparable module and compare nodes using their data attribute
  def <=>(other)
    data <=> other.data
  end
end

n1 = Node.new(4)
n2 = Node.new(4)
