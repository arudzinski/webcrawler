class PageLink < ActiveRecord::Base

  # accessors

  # relations
  belongs_to :source_page, :class_name => "Page", :foreign_key => "source_page_id"
  belongs_to :target_page, :class_name => "Page", :foreign_key => "target_page_id"

  # callbacks

  # named_scopes

  # validations
  # validates_presence_of
  # validates_uniqueness_of
  # validates_numeracility_of

  attr_accessible :source_page_id, :target_page_id


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

end
