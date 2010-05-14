class Crawler < ActiveRecord::Base
  LINKS_LIMIT = 3
  DEPTH_LIMIT = 3

  # relations
  has_many :pages   #zwraca obiekt relacji (tozsamy z tablica) zawierajacy wszystkie strony stworzone za pomoca tego crawlera

  attr_accessible :name, :root_domain, :root_page

  public

  #-------------------------------------------------------------------
  #---------------------- { INSTANCE METHODS } -----------------------
  #-------------------------------------------------------------------

  #zwraca adres url strony startowej na podstawie domeny i nazwy podstrony
  def root_page
    if root_domain
      "http://" + "#{root_domain}/#{read_attribute(:root_page)}".gsub('http://', '')
    else
      "http://#{read_attribute(:root_page).gsub('http://', '')}"
    end
  end

  #Usuwa wszystkie strony znalezione podczas poprzedniego procesu crwalingu oraz Inicjalizuje nowy proces crawlingu stron.
  def crawl
    pages.destroy_all
    
    cs = CrawlingStack.new

    Crawl.new(self.id, root_page, 0, cs, nil,
              :links_normalizer => {},
              :links_filter => {})
  end

   #zwraca tablicę haszującą (asocjacyjną) zawierająca obiekty stron jako kluczee oraz tablice haszujace zawierajace informacje o relacjach wzgledem danej strony jako wartosci 
  def get_relation_matrix
    pages.inject({}) do |result, page|
      result[page] = page.references
      result
    end
  end

end