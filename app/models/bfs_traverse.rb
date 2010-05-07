class BfsTraverse
  attr_reader :result

  def initialize(node, search=nil)
    @queue = BfsQueue.new
    @search = search
    @result = []
    @node = node
  end


  def traverse
    @result.clear
    @queue.clear

    @queue.enqueue(@node)
    @result.push @node

    while not @queue.empty?
      node = @queue.dequeue
      puts "Visiting node: #{node}"
      return node if (@search and node==@search)
      node.children.each do |node|
        unless @result.include?(node)
          @result.push(node)
          @queue.enqueue(node)
        end
      end
    end
    return result
  end

end


class BfsQueue < Array
  alias_method :enqueue, :push
  alias_method :dequeue, :shift
end