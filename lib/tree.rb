require "./lib/node.rb"
require "pry-byebug"

class Tree
  def initialize(arr, first, last)
    @root = build_tree(arr, first, last)
  end

  def build_tree(arr, first, last)
    puts "Building tree..."    
    # first, sort and remove dups
    if arr.nil?
      return nil
    else
      arr.uniq!
      arr.sort!
    end

    # turn into balance binary tree full of Node objects appropriately placed
    # first = 0
    # last = arr.length - 1

    return nil if first > last

    mid = (first + last) / 2
    node = Node.new(arr[mid])

    # base case
    # return node if first > last

    

    # recurisvely do these steps
      # calculate mid of left subarr and make it root of left subtree of "node"
      # calculate mid of right subarr and mkae it root of right subtree of "node"

    # left_arr = arr[first..mid-1]
    node.left_child = build_tree(arr, first, mid-1)
    
    # right_arr = arr[mid+1..last]
    # byebug
    node.right_child = build_tree(arr, mid+1, last)

    
    byebug
    return node
  end

end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
arr = [1,2,3,4,5,6,7,8,9]
tree = Tree.new(arr, 0, arr.length-1)