class CreatePageLinks < ActiveRecord::Migration
  def self.up
    create_table :page_links do |t|
      t.integer :source_page_id
      t.integer :target_page_id
      #t.timestamps
    end
  end

  def self.down
    drop_table :page_links
  end
end