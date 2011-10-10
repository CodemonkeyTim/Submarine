class AddListItemTemplateForSubcontract < ActiveRecord::Migration
  def self.up
    ListItemTemplate.create(:item_data => "Signed Subcontract", :item_type => 3, :rep_type => 1 )
  end

  def self.down
    ListItemTemplate.find_by_item_data("Signed Subcontract").delete
  end
end
