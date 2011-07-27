class ChecklistItem < ActiveRecord::Base
  belongs_to :listable, :polymorphic => true
  
end
