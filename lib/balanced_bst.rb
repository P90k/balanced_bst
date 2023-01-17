# frozen_string_literal: true

class Node
  include Comparable
  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  def initialize(arr)
    @array = arr # note to self: array can be unsorted.
    @root = # will hold value of build_tree method which has not been built yet
  end
end