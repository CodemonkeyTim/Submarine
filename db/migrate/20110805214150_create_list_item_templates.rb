class CreateListItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :list_item_templates do |t|
      t.string :item_data
      t.integer :item_type
      t.integer :rep_type
      t.timestamps
    end
    
    ListItemTemplate.create(:item_data => "Intent to Pay Prevailing Wage", :item_type => 1, :rep_type => 1 )
    ListItemTemplate.create(:item_data => "Bond Verified", :item_type => 1, :rep_type => 1 )
    ListItemTemplate.create(:item_data => "Certified Payroll Received", :item_type => 1, :rep_type => 2 )
    ListItemTemplate.create(:item_data => "Affidavit of Wages Paid Filed", :item_type => 1, :rep_type => 3 )
    
    ListItemTemplate.create(:item_data => "Insurance Verified", :item_type => 3, :rep_type => 1 )
    ListItemTemplate.create(:item_data => "Prior Payments Conditional Release of Lien Sent", :item_type => 3, :rep_type => 2 )
    ListItemTemplate.create(:item_data => "Payment to Lower-Tier Subs (if-present) Verified", :item_type => 3, :rep_type => 2 )
    ListItemTemplate.create(:item_data => "Payment to Suppliers (if-present) Verified", :item_type => 3, :rep_type => 2 )
    ListItemTemplate.create(:item_data => "Punch List Complete", :item_type => 3, :rep_type => 3 )
    ListItemTemplate.create(:item_data => "Unconditional Release of Lien Sent", :item_type => 3, :rep_type => 3 )
        
  end

  def self.down
    drop_table :list_item_templates
  end
end
