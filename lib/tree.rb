require "./lib/node.rb"
require "pry-byebug"

class Tree
  def initialize(arr, first, last)
    @root = build_tree(arr.sort.uniq, first, last)
    pretty_print
  end

  def build_tree(arr, first, last)
    puts "Building tree..."    
    # first, sort and remove dups
    if arr.nil?
      return nil
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
  end
  
  def delete(value)
    new_node = Node.new(value)
    curr_node = @root
    
    # traverse until child of parent node is == to value, if child is nil, do nothing
    until curr_node.left_child == new_node || curr_node.right_child == new_node || curr_node == new_node do
      if new_node < curr_node
        curr_node = curr_node.left_child
      elsif new_node > curr_node
        curr_node = curr_node.right_child
      end
      # by the end of the loop, curr_node should be the parent of the child we are trying to remove
    end
    
    if curr_node == new_node
      byebug
      # case 1: curr_node has no children
        # shouldn't exist because an array of numbers are given
      # case 2: curr_node has 1 child
      if !curr_node.right_child.nil? && curr_node.left_child.nil?
        # do something
      elsif curr_node.right_child.nil? && !curr_node.left_child.nil?
      # case 3: curr_node has 2 children
      elsif !curr_node.right_child.nil? && !curr_node.left_child.nil?
        # find next smallest biggest to the node we want to delete by looking in right subtree
        iter = curr_node.right_child
        until iter.left_child.left_child.nil?
          iter = iter.left_child
        end
        # with the smallest biggest value, swap with the node we want to delete
        curr_node.data = iter.left_child.data
        # if it had right children, let iter point to it's children
        if !iter.left_child.right_child.nil?
          iter = iter.right_child
        else
          iter.left_child = nil
        end
      end
    
    # WORKING WITH curr_node's right child
    elsif curr_node.right_child == new_node
      
      # case 1: (ONLY curr_node right child with NO CHILDREN is present) deleting leaf (very easy)
      if curr_node.right_child.left_child.nil? && curr_node.right_child.right_child.nil?
        puts "deleted"
        curr_node.right_child = nil
      # case 2: (ONLY curr_node right child's left child is present)
      elsif !curr_node.right_child.left_child.nil? && curr_node.right_child.right_child.nil?
        # point curr_node to it's right child's left child
        curr_node.right_child = curr_node.right_child.left_child
        # turn curr_node's right child to nil
        # curr_node.right_child = nil
      # case 2: (ONLY curr_node right child's right child is present)  
      elsif curr_node.right_child.left_child.nil? && !curr_node.right_child.right_child.nil?
        # point curr_node to it's right child's right child
        curr_node.right_child = curr_node.right_child.right_child
        # turn curr_node's right child to nil
        # curr_node.right_child = nil
      # case 3: curr_node right child has two children
      elsif !curr_node.right_child.left_child.nil? && !curr_node.right_child.right_child.nil?
        
        # find next smallest biggest to the node we want to delete by looking in right subtree
        iter = curr_node.right_child.right_child.left_child
        until iter.left_child.left_child.nil?
          iter = iter.left_child
        end
        # with the smallest biggest value, swap with the node we want to delete
        curr_node.right_child.data = iter.left_child.data
        # if it had right children, let iter point to it's children
        if !iter.left_child.right_child.nil?
          iter.left_child = iter.left_child.right_child
        end
      end
    # WORKING WITH curr_node's left child
    elsif curr_node.left_child == new_node

      # case 1: (ONLY curr_node left child with NO CHILDREN is present)
      if curr_node.left_child.left_child.nil? && curr_node.left_child.right_child.nil?
        puts "deleted"
        curr_node.left_child = nil
      # case 2: (ONLY curr_node left child's left child is present)
      elsif !curr_node.left_child.left_child.nil? && curr_node.left_child.right_child.nil?
        curr_node.left_child = curr_node.left_child.left_child
      # case 2: (ONLY curr_node left child's right child is present)
      elsif curr_node.left_child.left_child.nil? && !curr_node.left_child.right_child.nil?
        curr_node.left_child = curr_node.left_child.right_child
      # case 3: curr_node lefr child has two children
      elsif !curr_node.left_child.left_child.nil? && !curr_node.left_child.right_child.nil?
        # find next smallest biggest to the node we want to delete by looking in right subtree
        iter = curr_node.left_child.right_child.left_child
        until iter.left.left_child.nil?
          iter = iter.left_child
        end
        # with the smallest biggest value, swap with the node we want to delete
        curr_node.left_child.data = iter.left_child.data
        # if it had right children, let iter point to it's children
        if !iter.left_child.right_child.nil?
          iter.left_child = iter.left_child.right_child
        end
      end

      

    end

    pretty_print

  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
end

arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
arr = [1,2,3,4,5,6,7,8,9]
arr = [50, 30, 70, 20, 40, 60, 80]
tree = Tree.new(arr, 0, arr.length-1)

tree.delete(20)
tree.delete(30)
tree.delete(50)