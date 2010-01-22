class <%= class_name %> < ActiveRecord::Base

  # accessors

  # relations
<% attributes.select(&:reference?).each do |attribute| -%>
  belongs_to :<%= attribute.name %>
<% end -%>

  # callbacks

  # named_scopes

  # validations
  # validates_presence_of
  # validates_uniqueness_of
  # validates_numeracility_of

  attr_accessible <%= attributes.map{ |attribute| ":#{attribute.name}" unless attribute.type.to_s == "references" }.compact*', ' -%>


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
