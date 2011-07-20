class ChangeFieldTypeInListItems < ActiveRecord::Migration
  def self.up
    change_column("list_items", "touched_at", "time")
  end

  def self.down
  end
end
