
#klasa reprezentujaca strone (wierzcholek grafu)
class Page < ActiveRecord::Base

  belongs_to :crawler #zwraca obiekt crawlera, w ramach ktorego zostala stworzona dana strona
  has_many :page_links, :foreign_key => "source_page_id", :dependent => :destroy #zwraca obiekt relacji (tozsamy z tablica) zawierajacy wszystkie polaczenia (linki) wychodzace z danej strony
  has_many :pages, :class_name => "Page", :through => :page_links, :source => :target_page#zwraca obiekt relacji (tozsamy z tablica) zawierajacy wszystkie strony powiazane z obecna strona za pomoca page_links

  has_many :incoming_links, :foreign_key => "target_page_id", :class_name => "PageLink"
  attr_accessible :address, :title, :number_of_links

  public


  #-------------------------------------------------------------------
  #---------------------- { INSTANCE METHODS } -----------------------
  #-------------------------------------------------------------------

  #zwraca nazwę domeny wraz z protokolem na podstawie sowjego adresu
  def domain
    protocol, domain = address.split('//')
    [protocol, domain.split('/')[0..-2].join('/')].join('//')
  end

  #zwraca tablicę haszującą (asocjacyjną) zawierająca identyfikatory stron powiazanych z dana strona jako kluczee, oraz ilosci kolejno - zwrotnych, wychodzacych i przychodzacych linkow dla danej strony jako wartosci
  def references
    source_page_links = PageLink.find_all_by_source_page_id(id)
    target_page_links = PageLink.find_all_by_target_page_id(id)

    all_page_links = source_page_links | target_page_links
    unified_all_page_links = target_page_links + source_page_links

    relative_page_ids = all_page_links.map{|pl| [pl.source_page_id, pl.target_page_id]}.flatten.uniq

    Page.find(relative_page_ids).inject({}) do |page_references, page|


      page_references[page.id] = {
              :self_references => unified_all_page_links.select{|pl| (pl.source_page_id == self.id) and (pl.target_page_id == self.id) }.size/2,
              :outgoing_links => unified_all_page_links.select{|pl| (pl.source_page_id == page.id) and (pl.target_page_id == self.id) }.size,
              :incoming_links => unified_all_page_links.select{|pl| (pl.source_page_id == self.id) and (pl.target_page_id == page.id) }.size
      }

      page_references
    end

  end

  #-------------------------------------------------------------------
  #-------------------------- { For BFS } ----------------------------
  #-------------------------------------------------------------------


  #metoda wymagan przez klase BFS - jest aliasem dla metody pages
  def children
    pages
  end

  #metoda wymagana przez klase BFS - jest aliasem dla metody title
  def to_s
    title
  end



end
