class ChangeAnotherFieldTypeInListItems < ActiveRecord::Migration
  def self.up
    change_column("list_items", "touched_at", "datetime")
  end

  def self.down
  end
end
