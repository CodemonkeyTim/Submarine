class SubcontractorsController < ApplicationController
  def show 
    @sub_id = params[:id]
    @job_number = params[:job_number]
    
    @job = Job.find_by_job_number(@job_number)
    
    @subcontractor = Subcontractor.find(@sub_id)
    
    #Following block reads from log file and stores loggings into an array.
    @log = []
    
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{@subcontractor.name}-in-#{@job.job_number}.log", 'r') do |i|
      while line = i.gets
        @log.push(line)
      end
    end
    
    @all_subcontractors = Subcontractor.all
    @all_suppliers = Supplier.all
    
    if @subcontractor.contact_person.nil?
      @contact_person = ContactPerson.new(:name => "", :phone_number => "", :email => "") 
    end
    
    @overdue_items = @subcontractor.checklist_items.find_all_by_state(1)
    @open_items = @subcontractor.checklist_items.find_all_by_state(2)
    @waiting_items = @subcontractor.checklist_items.find_all_by_state(3)
    @completed_items = @subcontractor.checklist_items.find_all_by_state(4)
    
    @subcontractor.suppliers.each do |i|
      i.state = (@subcontractor.checklist_items.collect {|j| j.state} + i.checklist_items.collect {|j| j.state}).flatten.sort!.first
      if i.state.nil?
        i.state = 4
      end
    end 
    
  end

  def index
    @partners = Partner.find(:all)
  
  end
  
  def new
    @job = Job.find_by_job_number(params[:id])
    
  end
  
  def create
    
  end
  
  def create_address
    
  end

  def create_contact
    
  end
  
  def sort
    
  end
  
  def assign
    Job.find_by_job_number(params[:job_number]).subcontractors.push(Subcontractor.new(:name => params[:name]))
        
    File.open("/home/codemonkey/rails/Submarine/log/history_logs/#{params[:name]}-in-#{params[:job_number]}.log", 'w') do |i|
      i.write("Subcontractor assigned at #{Time.now}")
    end
  end
  
  def add_item
    
    
  end

end
