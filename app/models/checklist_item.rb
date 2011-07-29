class ChecklistItem < ActiveRecord::Base  
  belongs_to :listable, :polymorphic => true
  
  has_attached_file :document, :styles => {:medium => "300x300", :thumb => "20x20"}
  
end
