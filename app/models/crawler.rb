class Crawler < ActiveRecord::Base
  LINKS_LIMIT = 3
  DEPTH_LIMIT = 3
  TOTAL_LINKS = (DEPTH_LIMIT+1)*LINKS_LIMIT


  # accessors

  # relations
  has_many :pages

  # callbacks

  # named_scopes

  # validations
  # validates_presence_of
  # validates_uniqueness_of
  # validates_numeracility_of

  attr_accessible :name, :root_domain, :root_page

  private

  public

  #-------------------------------------------------------------------
  #------------------------ { CLASS METHODS } ------------------------
  #-------------------------------------------------------------------

  class << self

  end

  #-------------------------------------------------------------------
  #---------------------- { INSTANCE METHODS } -----------------------
  #-------------------------------------------------------------------

  def root_page
    "http://#{read_attribute(:root_page).gsub('http://', '')}"
  end

  def crawl
    require 'nokogiri'
    require 'open-uri'

    reset


    address, title, links = get_page(root_page)
    page = store_page(address, title, links.size)
    @links_processed = 1

    deep_crawl(links, page)
    update_attribute(:finish_time, Time.now)
  end

  def reset
    Page.destroy_all(:crawler_id => id)
    update_attribute(:start_time, Time.now)
  end

  def deep_crawl(links, page, depth = 1)
    links.first(LINKS_LIMIT).each do |link|
      process_link(link, page, depth)
    end
  end

  def process_link(link, page, depth)
    @links_processed += 1
    puts "#{((@links_processed)*100.0)/TOTAL_LINKS.to_f }% Processing link: #{link[:href]}"


    if link[:href] && link[:href].starts_with?('http://')
      begin
        address, title, links = get_page(link[:href])

        target_page = store_page(address, title, links.size)
        page.pages << target_page

        deep_crawl(links, target_page, depth + 1) if should_crawl_further?(links, depth)
      rescue => exc
        puts "There was a problem during connect with #{link[:href]} -> #{exc.message}"
      end
    else
      puts "Malformed link detected (probably javascript call)"
    end

  end

  def should_crawl_further?(links, depth)
    not (depth >= DEPTH_LIMIT)
  end


  def store_page(address, title, links_count)
    self.pages.create(:address => address, :title => title, :number_of_links => links_count)
  end

  def get_page(page_address)
    doc = Nokogiri::HTML(open(page_address))
    page_title = (title_container = doc.css('title').first) ? title_container.content : "Title unknown"
    links = doc.css("a")

    [page_address, page_title, links]
  end

end
