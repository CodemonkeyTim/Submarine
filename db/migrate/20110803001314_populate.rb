class Populate < ActiveRecord::Migration
  def self.up
     File.open("/home/submarine/rails/Submarine/public/import/vendors.txt", 'r') do |pop|
       while line = pop.gets
         Partner.create :name => line
       end  
     end
  end

  def self.down
  end
end
