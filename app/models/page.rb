class Page < ActiveRecord::Base

  # accessors

  # relations
  belongs_to :crawler


  has_many :page_links, :foreign_key => "source_page_id", :dependent => :destroy
  has_many :pages, :class_name => "Page", :through => :page_links, :source => :target_page


  # callbacks

  # named_scopes

  # validations
  # validates_presence_of
  # validates_uniqueness_of
  # validates_numeracility_of

  attr_accessible :address, :title, :number_of_links


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

  def domain
    protocol, domain = address.split('//')
    [protocol, domain.split('/')[0..-2].join('/')].join('//')
  end

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

#      throw Page.find(relative_page_ids).size if self.id == 86
#      throw all_page_links.map{|x| "#{x.source_page_id}->#{x.target_page_id}"}.join(' ||| ') if self.id == 86

      page_references
    end

  end

  #-------------------------------------------------------------------
  #-------------------------- { For BFS } ----------------------------
  #-------------------------------------------------------------------

  def children
    pages
  end

  def to_s
    title
  end



end
