class Document < ActiveRecord::Base
  belongs_to :assignment
  belongs_to :job
  has_attached_file :document
  
end
