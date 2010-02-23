class LinkFilter
  VALID_OPTIONS_KEYS = [:no_https, :no_js, :no_forum, :no_blog, :not_outside_domains, :http_only, :no_invalid]

  attr_accessor :links
  attr_reader :options
  attr_reader :filtered_links

  def initialize(links_array=[], *args)
    @options = args.extract_options!
    @options.assert_valid_keys(VALID_OPTIONS_KEYS)

    @options[:no_https] ||= true
    @options[:no_invalid] ||= true
    @options[:http_only] ||= true
    @options[:no_js] ||= true
    @options[:no_forum] ||= true
    @options[:no_blog] ||= true
    @options[:not_outside_domains] ||= []

    links = links_array
  end

  def links=(links_array)
    @links = links_array
    filter!
  end


  def filter!
    @filtered_links = @links.reject do |link|
      VALID_OPTIONS_KEYS.map{|method_name| send method_name, link, @options[method_name]}.any?
    end
  end

  private

  def no_https(link, *args)
    return false unless args.first
    link["href"].starts_with?('https://')
  end

  def http_only(link, *args)
    return false unless args.first
    not (link["href"].starts_with?('/') or link["href"].starts_with?('http://'))
  end

  def no_js(link, *args)
    return false unless args.first
    !link["onclick"].blank? or link['href']=="#"
  end

  def no_forum(link, *args)
    return false unless args.first
    link["href"].include?("forum")
  end

  def no_blog(link, *args)
    return false unless args.first
    link["href"].include?("blog")
  end

  def not_outside_domains(link, *args)
    return false if args.first.blank?
    no_protocol = link["href"].split('//').last
    domain = no_protocol.split(/[?\/]/).first
    not (args.any?{|domain_suffix| domain.ends_with?(domain_suffix)})
  end

  def no_invalid(link, *args)
    return false unless args.first
    link["href"].blank?
  end

end