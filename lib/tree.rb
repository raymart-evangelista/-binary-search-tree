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

    return nil if first > last

    # base case
    mid = (first + last) / 2
    
    node = Node.new(arr[mid])

    # recurisvely do these steps
      # calculate mid of left subarr and make it root of left subtree of "node"
      # calculate mid of right subarr and mkae it root of right subtree of "node"

    node.left_child = build_tree(arr, first, mid-1)

    node.right_child = build_tree(arr, mid+1, last)
    
    return node
  end

  def insert(value)
    # do not insert anything if tree already has value
    # compare value to root, recurse down 
    new_node = Node.new(value)
    curr_node = @root

    # is 0 less than or greater than 5? less than -> go into left child
    # is 0 less than or greater than 2? less than -> go into left child
    # is 0 less than or greater than 1? less than -> go into left child if !nil else 1.child = value
    until new_node == curr_node || curr_node.left_child.nil? || curr_node.right_child.nil? do
      # traverse down the tree
      if new_node < curr_node
        curr_node = curr_node.left_child
      elsif new_node > curr_node
        curr_node = curr_node.right_child
      end

      if !curr_node.left_child.nil? && new_node == curr_node.left_child
        puts "node already exists bro"
        return
      elsif !curr_node.right_child.nil? && new_node == curr_node.right_child
        puts "node already exists man"
        return
      end
    end

    if new_node < curr_node
      curr_node.left_child = new_node
    elsif new_node > curr_node
      curr_node.right_child = new_node
    elsif new_node == curr_node
      puts "node already exists"
    end
    byebug
  end
  
  def delete(value)
    # 3 cases
    # deleting leaf (very easy)
    # deleting node with one child (have node's parent point to that node's child)
    # deleting node with two children (find value that is next biggest to node within the children, )

  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
arr = [1,2,3,4,5,6,7,8,9]
tree = Tree.new(arr, 0, arr.length-1)

tree.insert(9)