class Document < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :job
  belongs_to :checklist_item
  has_attached_file :document
  
end
