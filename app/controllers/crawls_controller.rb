#klasa Kontrolera crawlingów - zapewnia obsuge komunikacji pomiedzy GUI a logiką biznesową modelu Crawl
class CrawlsController < ApplicationController

  def new
    if @crawler = Crawler.find_by_id(params[:crawler_id])
      @crawler.crawl
    end

    redirect_to crawler_path(@crawler)
  end


end