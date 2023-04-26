# frozen_string_literal: true

class Node
  include Comparable
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root, :array

  def initialize(arr)
    @array = arr.slice(0..-1).sort.uniq
    @root = build_tree
  end

  def build_tree(arr = @array)
    return nil if arr.nil? || arr.empty? # case: no array given, could be a leaf node. 
    return Node.new(arr[0]) if arr.length == 1 # return leaf node

    midpoint = arr[(arr.length - 1) / 2] # midpoint is root of tree
    left_tree = build_tree(arr[0...(arr.index(midpoint))])
    right_tree = build_tree(arr[arr.index(midpoint) + 1..arr.length])

    Node.new(midpoint, left_tree, right_tree) # constructing BST
  end

  def update_tree
    @root = build_tree(@array.sort.uniq)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    @array << value
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif value > node.data
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def find_parent(node, tree = @root)
    # if both children are
 

    return 'Node not found in tree' if tree.left.nil? && tree.right.nil?
    
    return tree if tree.left == node || tree.right == node
    
    if tree.left.nil? 
      return tree if tree.right == node
    end

    # continue search
    node.data < tree.data ? find_parent(node, tree.left) : find_parent(node, tree.right)
  end

  def inorder_successor(node)
    actual_node = find(node)
    left_node = actual_node.left

    return actual_node.data if left_node.nil?

    inorder_successor(left_node.data)
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end

  def count_children(value)
    node = find(value)
    return 2 if node.left != nil && node.right != nil
    return 1 if node.left != nil || node.right != nil
    0 # 0 will be returned if above statements not returned, meaning node has 0 children
  end

  def delete_node_one_child(node)
    parent = find_parent(node)
    node.left.nil? ? child_node = node.right : child_node = node.left
    parent.left == node ? parent.left = child_node : parent.right = child_node
  end

  def delete_node_two_children(node)
    successor = find(inorder_successor(node.right.data))
    parent_successor = find_parent(successor)
    if parent_successor.data == node.data
      node.data = successor.data
      node.right = successor.right
    else
      node.data = successor.data
      parent_successor.left = successor.right
    end
  end

  def delete(value, node = @root)
    current_node = find(value) # returns the node if node.data == value
    number_of_children = count_children(value)
  
    return delete_node_one_child(current_node) if number_of_children == 0
    return delete_node_one_child(current_node) if number_of_children == 1
    return delete_node_two_children(current_node) if number_of_children == 2

  end

  def level_order(tree = @root)
    queue = [tree.data]
    array_of_values = []    
    while queue.length > 0
      visited_node = find(queue.shift)
      left_tree = visited_node.left
      right_tree = visited_node.right
      queue << left_tree.data unless left_tree.nil?
      queue << right_tree.data unless right_tree.nil?
      array_of_values << visited_node.data unless block_given?
      yield(visited_node.data) if block_given?
    end
    array_of_values unless block_given?
  end

  def in_order(queue = [@root.data], tree = @root, array_of_values=[])
    
    if tree.left.nil? && queue.length > 0
      visited_node = queue.pop
      array_of_values << visited_node
      yield(visited_node) if block_given?
    end
    unless tree.left.nil?
      queue << tree.left.data
      in_order(queue, tree.left, array_of_values)
    end

    if tree.right.nil? && queue.length > 0
      visited_node = queue.pop
      array_of_values << visited_node
      yield visited_node if block_given?
    end
    unless tree.right.nil?
      queue << tree.right.data
      in_order(queue, tree.right, array_of_values)
    end
    array_of_values unless block_given?
  end

  def pre_order(queue = [@root.data], tree = @root, array_of_values = [], &block)
    visited_node = queue.pop 
    yield visited_node if block_given?
    array_of_values << visited_node unless visited_node.nil?
    unless tree.left.nil?
      visited_node = tree.left.data
      queue << visited_node
      pre_order(queue, tree.left, array_of_values, &block)
    end
    unless tree.right.nil?
      visited_node = tree.right.data
      queue << visited_node
      pre_order(queue, tree.right, array_of_values, &block)
    end
    array_of_values unless block_given?
  end

  def post_order(queue = [@root.data], tree = @root, array_of_values = [], &block)
    unless tree.left.nil?
      visited_node = tree.left.data
      queue << visited_node
      post_order(queue, tree.left, array_of_values, &block)
    end
    unless tree.right.nil?
      visited_node = tree.right.data
      queue << visited_node
      post_order(queue, tree.right, array_of_values, &block)
    end

    visited_node = queue.pop
    array_of_values << visited_node

    yield(visited_node) if block_given?
    array_of_values unless block_given?
  end

  def depth(node)
    Integer === node ? node_tree = find(node) : node_tree = node
    number_of_children = count_children(node_tree.data)

    return 0 if number_of_children == 0
    if number_of_children == 1
      node_tree.left.nil? ? 1 + depth(node_tree.right) : 1 + depth(node_tree.left)
    elsif number_of_children == 2
      right_subtree = 1 + depth(node_tree.right)
      left_subtree = 1 + depth(node_tree.left)
      left_subtree < right_subtree ? right_subtree : left_subtree
    end
  end
end

# example code
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
tree.insert(2)
tree.insert 15
tree.insert 100
tree.insert 10
tree.insert 11
tree.pretty_print
