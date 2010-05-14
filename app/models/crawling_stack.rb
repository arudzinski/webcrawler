#klasa reprezentujaca kolejke crawlingu - dziedziczy po klasie Array 
class CrawlingStack < Array

  #Metod jest aliasem dla metody push klasy nadrzednej Array
  def enqueue(e)
    push(e)
  end

end