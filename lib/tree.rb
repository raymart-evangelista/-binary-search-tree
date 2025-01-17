require "./lib/node.rb"
require "pry-byebug"

class Tree
  def initialize(arr)
    arr.sort!.uniq!
    @root = build_tree(arr)
    pretty_print
  end

  def build_tree(arr, first=0, last=arr.length-1)
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

  def insert(value, node=@root)
    # if value exists already
    if value == node.data
      return nil
    end

    if value < node.data
      # base case
      if node.left_child.nil?
        node.left_child = Node.new(value)
      else
        # recursive case
        insert(value, node.left_child)
      end
    elsif value > node.data
      # base case
      if node.right_child.nil?
        node.right_child = Node.new(value)
      else
        # recursive case
        insert(value, node.right_child)
      end
    end
  end
  
  def delete(value, node=@root)
    # base case
    if node.nil?
      return node
    end

    if value < node.data
      # traverse left 
      node.left_child = delete(value, node.left_child)
    elsif value > node.data
      # traverse right
      node.right_child = delete(value, node.right_child)
    # if key is same as node's value, then this is the node to be deleted
    else
      # node with only one child or no child
      if node.left_child.nil?
        return node.right_child
      elsif node.right_child.nil?
        return node.left_child
      end

      # node with two children: get smallest in the right subtree to take over deleted node's spot
      node.data = minValue(node.right_child)
      
      node.right_child = delete(node.data, node.right_child)

    end

    return node

    pretty_print

  end

  def minValue(node)
    min_val = node.data
    until node.left_child.nil?
      min_val = node.left_child.data
      node = node.left_child
    end
    return min_val
  end

  def find(value, node=@root)
    # base case, node doesn't exist, so exit out
    if node.nil?
      return nil
    # base case, node exists and equals the value we are looking for
    elsif value == node.data
      return node
    # recursive cases
    elsif
      if value < node.data
        return find(value, node.left_child)
      elsif value > node.data
        return find(value, node.right_child)
      end
    end
  end

  def level_order(&block)
    # arr to be used as queue
    node = @root
    queue = []
    ordered = []
    # if tree is empty, return nil
    if node.nil?
      return nil
    else
    # traverse tree in breadth-first level order
      queue.push(node)
      until queue.empty? do
        curr_node = queue[0]
        ordered.push(curr_node.data)
        queue.push(curr_node.left_child) if !curr_node.left_child.nil?
        queue.push(curr_node.right_child) if !curr_node.right_child.nil?
        # remove node form queue once finished
        #yield each node to the provided block
        block.call(queue[0]) if block_given?
        queue.shift
      end
    end
    return ordered
    # return array of values if no block given

  end

  # <left><root><right>
  def inorder(node=@root, values=[], &block)
    # base case
    return nil if node.nil?
    # visit left subtree
    inorder(node.left_child, values, &block)
    # visit root
    if block_given?
      block.call(node)
    else
      values.push(node.data)
    end
    # visit right subtree
    inorder(node.right_child, values, &block)

    return values
  end

  # <root><left><right>
  def preorder(node=@root, values=[], &block)
    # base case
    return nil if node.nil?
    # visit root
    if block_given?
      block.call(node)
    else
      values.push(node.data)
    end
    # visit left subtree
    preorder(node.left_child, values, &block)
    # visit right subtree
    preorder(node.right_child, values, &block)

    return values
  end

  # <left><right><root>
  def postorder(node=@root, values=[], &block)
    # base case
    return nil if node.nil?
    # visit left subtree
    postorder(node.left_child, values, &block)
    # visit right subtree
    postorder(node.right_child, values, &block)
    # visit root
    if block_given?
      block.call(node)
    else
      values.push(node.data)
    end

    return values
  end

  def height(node=@root, l_height=0, r_height=0)
    # parameter is a node, height of that node is returned
    # height is defined as the number of edges in longest path from a given node to a leaf node
    
    # base case
    return 0 if node.nil?


    # if the node has children, traverse
    if !node.left_child.nil?
      l_height += 1
      l_height = height(node.left_child, l_height, r_height)
    end
    if !node.right_child.nil?
      r_height += 1
      r_height = height(node.right_child, l_height, r_height)
    end
    
    if l_height > r_height
      return l_height
    else
      return r_height
    end
    

  end

  # depth is the number of edges in path from given node to tree's root node
  def depth(given_node=@root, parent_node=@root, edges=0)
    # base case given node is the root node
    return 0 if given_node == parent_node
    # base case tree doesn't exist
    return nil if parent_node.nil?

    if given_node < parent_node
      edges += 1
      depth(given_node, parent_node.left_child, edges)
    elsif given_node > parent_node
      edges += 1
      depth(given_node, parent_node.right_child, edges)
    end
    return edges
  end

  def balanced?(parent=@root)
    l_child = parent.left_child
    r_child = parent.right_child
    difference = height(l_child) - height(r_child)
    if difference <= 1 && difference >= -1
      return true
    else
      return false
    end
  end

  def rebalance
    new_arr = []
    inorder { |node| new_arr.push(node.data)}
    @root = build_tree(new_arr)
    
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
  
end

arr = Array.new(15) { rand(1..100) }
arr = [5, 13, 31, 38, 40, 46, 47, 53, 55, 67, 77, 77, 85, 90, 97]
p arr.sort
tree = Tree.new(arr)
p tree.balanced?
p tree.level_order
p tree.postorder
p tree.preorder
p tree.inorder
tree.insert(101)
tree.insert(102)
tree.insert(103)
tree.insert(104)
p tree.balanced?
tree.rebalance
p tree.balanced?

p tree.level_order
p tree.postorder
p tree.preorder
p tree.inorder