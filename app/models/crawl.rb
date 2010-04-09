class Crawl

  def initialize(crawler_id, url, depth, cs, parent_page_id=nil, *args)

    @options = args.extract_options!
    @normalizer = false
    @filter = false
    @crwlr = ::Crawler.find(crawler_id)
    @stack = cs
    @url, @depth, @parent_page =  url, depth, ::Page.find_by_id(parent_page_id)
    perform
  end

  def perform
    if perform_crawl?
      get_page
      store_page
      normalize_links
      filter_links
      continue_crawl
    else
      puts "Depth limit reached for #{@url}"
    end
  end

  private

  def continue_crawl
    puts "I am on #{@url} -> I want to navigate to #{@links.map{|l| l['href']}}"

    @links.each do |link|
      href = link["href"]
      href = @stored_page.domain + '/' + href unless href.starts_with?("htt")
      if page_found = Page.find_by_address_and_crawler_id(href, @crwlr.id)
        puts "Loop for #{href}"
        if @stored_page
          @stored_page.pages << page_found
        end
      else
        puts "Adding job for CID: #{@crwlr.id} HREF: #{href} SPID: #{@stored_page.id} #{} #{} #{}"
        @stack.enqueue Crawl.new(@crwlr.id, href, @depth+1, @stack, @stored_page.id, @options)
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
    @stored_page = @crwlr.pages.create(:address => @url, :title => @page_title, :number_of_links => @links.size)
    if @parent_page
      @parent_page.pages << @stored_page
    end
  end


end