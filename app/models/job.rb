class Job < ActiveRecord::Base
  has_and_belongs_to_many :suppliers
  has_and_belongs_to_many :subcontractors
  
  has_many :logs, :as => :loggable
  
  attr_accessor :state
  
  def state
    @state
  end
  
end
