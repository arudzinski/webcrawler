#klasa Kontrolera stron - zapewnia obsuge komunikacji pomiedzy GUI a logiką biznesową modelu Page
class PagesController < ApplicationController
  include ParamsToConditions

  before_filter :get_pages, :only => [:index]
  before_filter :get_page, :except => [:index, :create, :new]

  def index
    respond_to do |format|
      format.html
    end
  end

  def show
    respond_to do |format|
      format.html
    end
  end

  private

  def get_page
    @page = Page.find(params[:id])
  end

  def get_pages
    @pages = Page.find(:all, :conditions => get_conditions_from_params(:crawler_id)).paginate(:page => params[:page], :per_page => 10)
  end
end