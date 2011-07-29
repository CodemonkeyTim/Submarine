class SuppliersController < ApplicationController
  def show
    @supplier = Supplier.find(params[:id])
    @job = Job.find_by_job_number(params[:job_number])
    @subcontractor  = @supplier.subcontractors.find(params[:sub_id])
    
    #Following block reads from log file and stores loggings into an array.
    @log = []
    
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{@supplier.name}-in-#{@job.job_number}-for-#{@subcontractor.name}.log", 'r') do |i|
      while line = i.gets
        @log.push(line)
      end
    end
    
    @overdue_items = @supplier.checklist_items.find_all_by_state(1)
    @open_items = @supplier.checklist_items.find_all_by_state(2)
    @waiting_items = @supplier.checklist_items.find_all_by_state(3)
    @completed_items = @supplier.checklist_items.find_all_by_state(4)
    
    if @supplier.contact_person.nil?
      @contact_person = ContactPerson.new(:name => "", :phone_number => "", :email => "") 
    end
    
  end

  def index
  end
  
  def new
    @job = Job.find_by_job_number(params[:job_number])
    @subcontractor = Subcontractor.find(params[:id])
  end

  def assign
    Job.find_by_job_number(params[:job_number]).subcontractors.find(params[:id]).suppliers.push(Supplier.new(:name => params[:name]))
        
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{params[:name]}-in-#{params[:job_number]}-for-#{Subcontractor.find(params[:id]).name}.log", 'w') do |i|
      i.write("Supplier assigned to #{Subcontractor.find(params[:id]).name} at #{Time.now}")
    end
  end
  
  def create
    
  end
end
