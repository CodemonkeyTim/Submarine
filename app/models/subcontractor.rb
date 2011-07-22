class Subcontractor < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :subcontractors
  has_and_belongs_to_many :suppliers
  has_many :checklist_items, :as => :listable
end
