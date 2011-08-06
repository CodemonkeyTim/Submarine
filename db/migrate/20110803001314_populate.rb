class Populate < ActiveRecord::Migration
  def self.up
     File.open("/home/michaelleland/rails/Submarine/public/import/vendors.txt", 'r') do |pop|
       while line = pop.gets
         Partner.create :name => line
       end  
     end
      f = File.open("/home/michaelleland/rails/Submarine/public/import/jobs.txt")
        dataarray = f.read.split("\n")
      f.close
      
      @linesarray =[]
        dataarray.each {|line| @linesarray << line.split("\t") }
        
        @jobs = []
        @linesarray.each do |line|
        job = Job.new(:name => line[1], :job_number => line[0])
        job.save # to database
        @jobs << job
    end
  end

  def self.down
  end
end
