class SubcontractorsController < ApplicationController
  def show     
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    
    @job = Job.find(@job_id)
    @subcontractor = Partner.find(params[:id])
    

    @log = @subcontractor.log_markings
    
    if @subcontractor.contact_person.nil?
      @contact_person = ContactPerson.new(:name => "", :phone_number => "", :email => "") 
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
        
  File.open("~/rails/Submarine/log/history_logs/#{params[:name]}-in-#{params[:job_number]}.log", 'w') do |i|
      i.write("Subcontractor assigned at #{Time.now}")
    end
  end
  
  def add_item
    
    
  end

end
