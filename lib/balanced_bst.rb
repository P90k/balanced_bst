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
    @array = arr.sort.uniq
    @root = build_tree
  end

  def build_tree(arr = @array)
    return nil if arr.nil? || arr.empty?
    return Node.new(arr[0]) if arr.length == 1 # return leaf node

    midpoint = arr[(arr.length - 1) / 2]
    left_tree = build_tree(arr[0...(arr.index(midpoint))])
    right_tree = build_tree(arr[arr.index(midpoint) + 1..arr.length])

    Node.new(midpoint, left_tree, right_tree) # constructing binary search tree.
  end

  def update_tree
    @root = build_tree
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end

  def insert(value, node = @root)
    if value < node.data
      node.left.nil? ? node.left = Node.new(value) : insert(value, node.left)
    elsif value > node.data
      node.right.nil? ? node.right = Node.new(value) : insert(value, node.right)
    end
  end

  def delete(value)
    return 'Value is not in tree!' unless @array.include?(value)

    @array.delete(value)
    update_tree
  end

  def find(value, node = @root)
    return nil if node.nil?

    return node if node.data == value

    value < node.data ? find(value, node.left) : find(value, node.right)
  end
end

# example code
arr = [1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
tree = Tree.new(arr)
tree.insert(2)
tree.insert 15
tree.pretty_print
