=begin
    Klasa odpowiedzialna za przemierzenie grafu reprezentującego topologię stron zebranych za pośrednictwem danego crawlera za pomocą algorytmu BFS.
=end


class BfsTraverse
  attr_reader :result



  #Kontruktor, przyjmuje jako pierwszy parametr wierchołek (stronę) od której ma zacząc przemierzanie grafu (topologii).
  #Drugi parametr opcjonalny - przyjmuje wiercholek, ktor ma odszukac w obrebie grafu.
  def initialize(node, search=nil)
    @queue = BfsQueue.new      #BfsQueue
    @search = search    #Object
    @result = [] #Array
    @node = node  #Object
  end

 #Przemieza graf agregujac przemierzane wiercholki w tablicy, ktora pozniej zwracana jest jako wynik
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


# Klasa implementująca metody kolejki w oparci o standardową implementację tablicy w języku Ruby
class BfsQueue < Array
  alias_method :enqueue, :push
  alias_method :dequeue, :shift
end