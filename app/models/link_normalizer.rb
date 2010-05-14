#Klasa która docelowo ma byc odpowiedzialna za kanonizacje linkow

class LinkNormalizer

  #getter, umozliwiajacy dostep do oryginalnej, nieskanonizowanej listy linkow
  attr_reader :links
  attr_reader :options

  #getter, umozliwiajacy dostep do skanonizowanej listy linkow
  attr_reader :normalized_links

  def initialize(links_array=[], *args)
    @options = args.extract_options! #Hash
    @links=links_array #Array
  end

  #setter, zapisujacy wewnatrze obiektu liste linkow i autoamtycznie ja normalizoujacy (kanonizujacy)
  def links=(links_array)
    @links = links_array
    normalize!
  end

  private

  def normalize!
    @normalized_links = @links  #TODO  #Array
  end

end