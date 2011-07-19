class AddDetailsToJob < ActiveRecord::Migration
  def self.up
    add_column :jobs, :owner_id, :integer
  end

  def self.down
    remove_column :jobs, :owner_id
  end
end
