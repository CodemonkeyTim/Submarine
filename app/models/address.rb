class Address < ActiveRecord::Base
  belongs_to :subcontractors
  belongs_to :suppliers
end