class Page < ActiveRecord::Base

  # accessors

  # relations
  belongs_to :crawler


  has_many :page_links, :foreign_key => "source_page_id"
  has_many :pages, :class_name => "Page", :through => :page_links,  :source => :target_page


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
    [protocol, domain.split('/').first].join('//')
  end

end
