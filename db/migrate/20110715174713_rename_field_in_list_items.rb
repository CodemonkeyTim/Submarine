class RenameFieldInListItems < ActiveRecord::Migration
  def self.up
    change_table :list_items do |t|
      t.rename :job_num, :job_number
    end
  end

  def self.down
  end
end
