class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :address
      t.string :title
      t.integer :number_of_links
      t.integer :crawler_id
      #t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end