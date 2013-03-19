require 'set'

class InvalidNode < StandardError; end;

class Graph
  def initialize
    @nodes = {}
    @edges = {}
  end

  def [](key)
    @nodes[key]
  end

  def add_node(key, node_obj)
    @nodes[key] = node_obj
    @edges[key] = {}

    self
  end

  def add_edge(tail,head, weight = nil)
    validate_node tail, "Tail"
    validate_node head, "Head"

    @edges[tail][head] = weight
    self
  end

  def backtrace(hierarchy, end_node)
    list = [end_node]
    current = end_node

    while node = hierarchy[current]
      list.unshift node
      current = node
    end

    list
  end

  def search(start_node_key, find_node_key, append_mode = :push)
    validate_node start_node_key, "Start"
    validate_node find_node_key, "Target"

    parent_list = {}
    
    frontier = @nodes.keys.to_set
    items = [start_node_key]
    frontier.delete start_node_key 

    while item = items.delete_at(0)
      return backtrace(parent_list, find_node_key) if item == find_node_key

       @edges[item].each do |head, value|
         if frontier.include?(head) 
           parent_list[head] = item
           frontier.delete head
           items.send append_mode, head  # push / unshift
         end
       end
    end
                    
    return nil
  end
  
  def bfs(start_node_key, find_node_key)
    search start_node_key, find_node_key, :push
  end

  def dfs(start_node_key, find_node_key)
    search start_node_key, find_node_key, :unshift
  end

  def validate_node(node, caption)
    raise InvalidNode, "#{caption} node does not exist" unless @nodes[node]
  end

  def connected_components(start_key = nil)
    node_keys = [start_key].to_set if start_key
    node_keys ||= @nodes.keys.to_set

    frontier = @nodes.keys.to_set

    components = []

    node_keys.each do |seed_node|
      if frontier.include?(seed_node)
        frontier.delete seed_node

        queue = [seed_node]
        component = [seed_node]

        while node = queue.delete_at(0)
          @edges[node].each do |head, value|
            if frontier.include?(head)
              frontier.delete head

              queue << head
              component << head
            end
          end
        end

        components << component
      end
    end

    components
  end
end
