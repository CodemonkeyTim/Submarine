class CreateListItemTemplates < ActiveRecord::Migration
  def self.up
    create_table :list_item_templates do |t|
      t.string :item_data
      t.integer :item_type
      t.integer :rep_type
      t.timestamps
    end
    
    /*
     * :item_type is used for differentiating between public job items and private job items.
     * :item_type => 1 is public jobs only
     * :item_type => 2 is private jobs only
     * :item_type => 3 is both public and private jobs
     *
     * :rep_type is used for differentiating between initial, repeating, and final items.
     * :rep_type => 1 are initial items 
     * :rep_type => 2 are repeating items
     * :rep_type => 3 are final items
     */


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
