class PagesController < ApplicationController

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
    @pages = Page.paginate :page => params[:page], :per_page => 10
  end
end