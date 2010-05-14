    #by uzupenic diagram klas, trzeba dodac nazwy wszystkich metod (np. initialize, filter!, links=, no_https...)
    #oraz dodac wszystkie pola (np. @options, @links, @filtered_links) te z małpkami na poczatku

    #metody sa po slowku def
    #pola sa po znaku @
#Klasa ddpowiedzialna za odfiltrowanie listy linkow z linkow nie spelniajacych zadanych kryteriow

class LinkFilter
  VALID_OPTIONS_KEYS = [:no_https, :no_js, :no_forum, :no_blog, :not_outside_domains, :http_only, :no_invalid]

   #getter, umozliwiajacy dostep do oryginalnej, nieprzefiltrowanej listy linkow
  attr_reader :links
  attr_reader :options
  #getter, umozliwiajacy dostep do przefiltorwanej listy linkow
  attr_reader :filtered_links


  #kontruktor przyjmujacy za pierwszy paraemtr liste linkow do odfiltorwania
  #jako drugi parametr mozna podac liste konfiguracji poszczegolnych subfiltrow
  def initialize(links_array=[], *args)
    @options = args.extract_options!        #Hash
    @options.assert_valid_keys(VALID_OPTIONS_KEYS)

    @options[:no_https] ||= true
    @options[:no_invalid] ||= true
    @options[:http_only] ||= false
    @options[:no_js] ||= true
    @options[:no_forum] ||= true
    @options[:no_blog] ||= true
    @options[:not_outside_domains] ||= []

    @links = links_array
  end

  #setter, zapisujacy wewnatrze obiektu liste linkow i autoamtycznie ja filtrujacy
  def links=(links_array)
    @links = links_array   #Array
    filter!
  end


  #filtruje liste linkow
  def filter!
    @filtered_links = @links.reject do |link|    #Array
      VALID_OPTIONS_KEYS.map{|method_name| send method_name, link, @options[method_name]}.any?
    end
  end

  private

  #zwraca true, jesli link prowadzi do strony opartej o protokol https
  def no_https(link, *args)
    return false unless args.first
    return false if link["href"].blank?
    link["href"].starts_with?('https://')
  end

  #zwraca true, jesli link nie prowadzi do strony opartej o protokol http
  def http_only(link, *args)
    return false unless args.first
    return true if link["href"].blank?
    not (link["href"].starts_with?('/') or link["href"].starts_with?('http://'))
  end

  #zwraca true, jesli link ma obsluzone zdarzenie onclick
  def no_js(link, *args)
    return false unless args.first
    !link["onclick"].blank? or link['href']=="#"
  end

  #zwraca true, jesli url linku zawiera slowo forum
  def no_forum(link, *args)
    return false unless args.first
    return false if link["href"].blank?
    link["href"].include?("forum")
  end

  #zwraca true, jesli url linku zawiera slowo blog
  def no_blog(link, *args)
    return false unless args.first
    return false if link["href"].blank?
    link["href"].include?("blog")
  end

  #zwraca true, jesli link prowadzi do strony znajdujacej sie na domenie innej niz domeny podane jako parametr
  def not_outside_domains(link, *args)
    return false if args.first.blank?
    return false if link["href"].blank?
    no_protocol = link["href"].split('//').last
    domain = no_protocol.split(/[?\/]/).first
    not (args.any?{|domain_suffix| domain.ends_with?(domain_suffix)})
  end

  #zwraca true, jesli atrybut href linku jest pusty
  def no_invalid(link, *args)
    return false unless args.first
    link["href"].blank?
  end

end