#klasa reprezentujaca jedno przejscie procesu crawlingu
class Crawl


  #Konstruktor. przyjmuje nastepujace parametery
  #identyfuikator crawlera do ktorego nalezy
  #url jaki powinien zostac odwiedzony
  #glebokosc w strukutrze linkow na jakiej dany proces sie osbywa
  #cs - obiekt stosu w ktorym przchowywane sa pozostale do odwiedzenia adresy url
  #parent_page_id - identyfikator strony, ktora zainicjalizowala dany proces
  #Konstruktor automatycznie uruchamia metode perform na obiekcie
  def initialize(crawler_id, url, depth, cs, parent_page_id=nil, *args)
    @options = args.extract_options! #hash
    @normalizer = false #boolean
    @filter = false             #boolean
    @crwlr = ::Crawler.find(crawler_id) #Crawler
    @stack = cs #CrawlingStack
    @url, @depth, @parent_page =  url, depth, ::Page.find_by_id(parent_page_id) #strong, integer, Page
    perform
  end

  #akcja ralizujaca proces crawlingu
  def perform
    if perform_crawl?
      if get_page
        store_page
        normalize_links
        filter_links
        continue_crawl
      end
    else
      puts "Depth limit reached for #{@url}"
    end
  end

  private

  #Kontynuacja crawlingu - na podstawie zebranej listy linkow wykrywane sa zapetlenia (ponowne odwiedzenia tych samych stron)
  # W tym wypadku tworzone jest jedynie dodatkowe polaczenie uzupelniajace zbudowana dotychczas topologie.
  #W przeciwnym wypadku, tworzony jest nowy obiekt crawlingu dla striny do ktorej kieruje dany link
  def continue_crawl
    puts "I am on #{@url} (#{@links.size} links)-> I want to navigate to #{@links.map{|l| l['href']}}"   #links - Array

    @links.each do |link|
      href = link["href"]
      next if href.blank?
      href = @stored_page.domain + '/' + href unless href.starts_with?("htt")
      if page_found = Page.find_by_address_and_crawler_id(href, @crwlr.id)
        puts "Loop for #{href}"
        if @stored_page     #Page
          @stored_page.pages << page_found
        end
      else
        puts "Adding job for CID: #{@crwlr.id} HREF: #{href} SPID: #{@stored_page.id} #{} #{} #{}"
        @stack.enqueue Crawl.new(@crwlr.id, href, @depth+1, @stack, @stored_page.id, @options)
      end
    end
  end

  #zwraca truem jesli glebokosc w strukturze linkow na jakiej pracuje crawler nie przekracza wartosci maksymlanej okreslonej przez stala DEPTH_LIMIT
  def perform_crawl?
    @depth < Crawler::DEPTH_LIMIT
  end

  #pobiera strone z danego adresu url, parsuje ja, zapisuje jej tytul w zmiennej instancji page_title oraz zapisuje liste odnalezionych na niej linkow w zmiennej instancji links
  def get_page
    begin
      require 'nokogiri'
      require 'open-uri'
      @page = Nokogiri::HTML(open(@url))
      @page_title = (title_container = @page.css('title').first) ? title_container.content : "Title unknown"
      @links = @page.css("a")

      return true
    rescue => exc
      puts "====================== Problem with URL #{@url} ====================== "
      puts "====================== #{exc.message}"
      return false
    end
  end


  #Uruchamia proces normalizacji (kanonizacji) na zestawie linkow
  def normalize_links
    if @normalizer
      @links = LinkNormalizer.new(@links).normalized_links
    end
  end

  #Uruchamia proces filtrowania
  def filter_links
    if @filter
      @links = LinkFilter.new(@links).filtered_links
    end
  end

  #Zapisuje obecna strone w bazie danych oraz tworzy polaczenie zapisanej strony ze strona z ktorej do obecnej strony prowadzilo hiperlacze
  def store_page
    @stored_page = @crwlr.pages.create(:address => @url, :title => @page_title[0..200], :number_of_links => @links.size)
    if @parent_page
      @parent_page.pages << @stored_page
    end
  end


end