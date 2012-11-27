class Node
  attr_accessor :children, :root, :freq

  def initialize(root)
    @root = root
    @freq = 0
    @children = {}
  end

  def increment_freq
    @freq += 1
  end

  def add_child(child)
    @children[child] = Node.new(child) if @children[child].nil?
    @children[child].increment_freq
  end
end

class Train

  def initialize
    gchatparser = GchatParser.new
    @training_set = gchatparser.training_set
    @roots = {}
  end

  def roots
    @roots
  end

  def search_freq(nodes)
    word = ''
    max = 0
    nodes.each do |key, value|
      if !key.nil?
        if value.freq > max
          word = key
          max = value.freq
        end
      end
    end
    word
  end

  def train
    @training_set.each do |sentence|
      @roots[sentence[0]] = Node.new(sentence[0]) if @roots[sentence[0]].nil?
      @roots[sentence[0]].increment_freq
      current_node = ''
      for i in (1..sentence.length)
        if i == 1
          @roots[sentence[0]].add_child(sentence[i])
          current_node = @roots[sentence[0]].children[sentence[i]]
        else
          current_node.add_child(sentence[i])
          current_node = current_node.children[sentence[i]]
        end
      end
    end
  end
end
