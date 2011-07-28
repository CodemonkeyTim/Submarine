class ContactPerson < ActiveRecord::Base
  has_many :subcontractors
  has_many :suppliers
end
