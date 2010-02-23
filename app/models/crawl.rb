class Crawl

  def initialize(crawler_id, url, depth, parent_page_id=nil, *args)
    @options = args.extract_options!
    @normalizer = false
    @filter = false
    @crawler, @url, @depth, @parent_page = ::Crawler.find(crawler_id), url, depth, ::Page.find_by_id(parent_page_id)

  end

  def perform
    if perform_crawl?
      get_page
      store_page
      normalize_links
      filter_links
      continue_crawl
    end
  end

  private

  def continue_crawl
    @links.each do |link|
      href = link["href"]
      href = @stored_page.domain + '/' + href unless href.starts_with?("htt")
      if Page.find_by_address(href)
        puts "Loop for #{href}"
      else
        puts "Crawling to #{href}"
        Delayed::Job.enqueue Crawl.new(@crawler.id, href, @depth+1, @stored_page.id, @options)
      end
    end
  end

  def perform_crawl?
    @depth < Crawler::DEPTH_LIMIT
  end

  def get_page
    require 'nokogiri'
    require 'open-uri'

    @page = Nokogiri::HTML(open(@url))
    @page_title = (title_container = @page.css('title').first) ? title_container.content : "Title unknown"
    @links = @page.css("a")
  end


  def normalize_links
    if @normalizer
      @links = LinkNormalizer.new(@links).normalized_links
    end
  end

  def filter_links
    if @filter
      @links = LinkFilter.new(@links).filtered_links
    end
  end

  def store_page
    @stored_page = @crawler.pages.create(:address => @url, :title => @page_title, :number_of_links => @links.size)
    if @parent_page
      @parent_page.pages << @stored_page
    end
  end


end