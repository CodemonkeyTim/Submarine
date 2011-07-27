class Subcontractor < ActiveRecord::Base
  has_and_belongs_to_many :jobs
  has_and_belongs_to_many :suppliers
  has_many :checklist_items, :as => :listable
  has_many :subtiersubcontractors, :class_name => "Subcontractor", :foreign_key => "supercontractor_id"
  belongs_to :supercontractor, :class_name => "Subcontractor"
  
  attr_accessor :state
  
  def state
    @state
  end
end
