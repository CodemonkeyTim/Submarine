class SubcontractorsController < ApplicationController
  def show 
    @sub_id = params[:id]
    @job_number = params[:job_number]
    
    @job = Job.find_by_job_number(@job_number)
    
    
    @all_subcontractors = Subcontractor.all
    @all_suppliers = Supplier.all
    
    @subcontractor = Subcontractor.find(@sub_id)
    
    if @subcontractor.contact_person.nil?
      @contact_person = ContactPerson.new(:name => "", :phone_number => "", :email => "") 
    end
    
    @overdue_items = @subcontractor.checklist_items.find_all_by_state(1)
    @open_items = @subcontractor.checklist_items.find_all_by_state(2)
    @waiting_items = @subcontractor.checklist_items.find_all_by_state(3)
    @completed_items = @subcontractor.checklist_items.find_all_by_state(4)
    
    @subcontractor.suppliers.each do |i|
      i.state = i.checklist_items.collect {|j| j.state}.flatten.sort!.first  
    end
    
    @subcontractor.subtiersubcontractors.each do |i|
      i.state = (i.checklist_items.collect {|j| j.state} + i.suppliers.collect {|k| k.checklist_items.collect {|l| l.state}}).flatten.sort!.first  
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
    Job.find_by_job_number(params[:job_number]).subcontractors.new(:name => params[:name]).save
  end
  
  def add_item
    
    
  end

end
