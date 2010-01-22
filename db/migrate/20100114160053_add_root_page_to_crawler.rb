class AddRootPageToCrawler < ActiveRecord::Migration
  def self.up
    add_column :crawlers, :root_page, :string
  end

  def self.down
    remove_column :crawlers, :root_page
  end
end
