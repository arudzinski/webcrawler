class CrawlersController < ApplicationController

  before_filter :get_crawlers, :only => [:index]
  before_filter :get_crawler, :except => [:index, :create, :new]

  def new
    @crawler = Crawler.new
  end

  def index
    respond_to do |format|
      format.html
    end
  end

  def show

    @relation_matrix_hash = if @crawler.pages.blank?
      nil
    else
      @crawler.get_relation_matrix
    end

    respond_to do |format|
      format.html
    end
  end

  def create
    @crawler = Crawler.new(params[:crawler])

    if @crawler.save
      flash[:notice] = "Crawler has been created succesfully"
    end

    respond_to do |format|
      format.html {redirect_to edit_crawler_path(@crawler)}
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def update
    if @crawler.update_attributes(params[:crawler])
      flash[:notice] = "Crawler has been updated succesfully"
    end

    respond_to do |format|
      format.html {redirect_to crawlers_path}
    end
  end

  def destroy
    @crawler.destroy
    respond_to do |format|
      format.html {redirect_to crawlers_path}
    end
  end


  private

  def get_crawler
    @crawler = Crawler.find(params[:id])
  end

  def get_crawlers
    @crawlers = Crawler.paginate :page => params[:page], :per_page => 30
  end
end