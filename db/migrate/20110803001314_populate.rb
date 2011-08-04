class Populate < ActiveRecord::Migration
  def self.up
     File.open("/home/michaelleland/rails/Submarine/public/vendors.txt", 'r') do |pop|
       while line = pop.gets
         Partner.create :name => line
       end  
     end
     File.readlines("/home/michaelleland/rails/Submarine/public/jobs.txt").map do |line|
       while id, name = line.split("\t")
         job = Job.new
         job.id = id
         job.name = name
       end
     end
  end

  def self.down
  end
end
