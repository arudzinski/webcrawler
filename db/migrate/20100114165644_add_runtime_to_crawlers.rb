class AddRuntimeToCrawlers < ActiveRecord::Migration
  def self.up
    add_column :crawlers, :start_time, :datetime
    add_column :crawlers, :finish_time, :datetime
  end

  def self.down
    remove_column :crawlers, :start_time
    remove_column :crawlers, :finish_time
  end
end
