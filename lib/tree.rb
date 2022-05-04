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

    # byebug

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

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right_child, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right_child
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left_child, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left_child
  end
  
end

# arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
# arr = [1,2,3,4,5,6,7,8,9]
# arr = [50, 30, 70, 20, 40, 60, 80]
arr = %w[a b c d e f g h i j k]
tree = Tree.new(arr, 0, arr.length-1)

p tree.level_order
tree.level_order { |node| p node.data }

# tree.insert(100)
# tree.insert(200)
# tree.insert(400)
# tree.pretty_print
# tree.delete(400)
# tree.pretty_print
# tree.delete(200)
# tree.pretty_print
# tree.delete(100)
# tree.pretty_print
# tree.delete(70)
# tree.pretty_print
# tree.delete(50)
# tree.pretty_print
# p tree.find(100)