class CreateListItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :list_item_templates do |t|
      t.string :item_data
      t.integer :item_type
      t.integer :rep_type
      t.timestamps
    end
    
    ListItemTemplate.create(:item_data => "Certified Payrolls", :item_type => 1, :rep_type => 1 )
    ListItemTemplate.create(:item_data => "Intent to Pay Prevailing Wage", :item_type => 1, :rep_type => 1)

    ListItemTemplate.create(:item_data => "Verification of Payment to Lower Tier Subcontractors", :item_type => 3, :rep_type => 1)
    ListItemTemplate.create(:item_data => "Receipt of Prior Payment's Conditional Release of Lien", :item_type => 3, :rep_type => 1)
    ListItemTemplate.create(:item_data => "Receipt of signed Unconditional Lien Release", :item_type => 3, :rep_type => 2)
    
    ListItemTemplate.create(:item_data => "Affidavit of Wages Paid", :item_type => 1, :rep_type => 2)
    ListItemTemplate.create(:item_data => "Punch List Completed", :item_type => 3, :rep_type => 2)

    ListItemTemplate.create(:item_data => "Verification that supplier has been paid ", :item_type => 4, :rep_type => 1)
    
  end

  def self.down
    drop_table :list_item_templates
  end
end
