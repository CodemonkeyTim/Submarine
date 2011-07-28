class Supplier < ActiveRecord::Base
  has_and_belongs_to_many :subcontractors
  has_many :checklist_items, :as => :listable
  
  belongs_to :contact_person
  
  attr_accessor :state
  
  def state
    @state
  end
end
