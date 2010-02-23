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

  def max_depth
    6
  end

  def crawl
    Delayed::Job.enqueue Crawl.new(id, root_page, 0, nil,
                                   :links_normalizer => {},
                                   :links_filter => {})
  end

end