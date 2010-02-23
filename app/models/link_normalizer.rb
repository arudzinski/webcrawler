class LinkNormalizer
  attr_accessor :links
  attr_reader :options
  attr_reader :normalized_links

  def initialize(links_array=[], *args)
    @options = args.extract_options!
    links=links_array
  end

  def links=(links_array)
    @links = links_array
    normalize!
  end

  def normalize!
    @normalized_links = @links.reject do |link|
      false
    end
  end

  private

end