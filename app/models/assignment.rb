class Assignment < ActiveRecord::Base
  has_many :checklist_items
  has_many :logs, :as => :loggable
  has_many :documents, :as => :owner
end
