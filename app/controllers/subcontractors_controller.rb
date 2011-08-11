class SubcontractorsController < ApplicationController
  def show     
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    
    @job = Job.find(@job_id)
    @subcontractor = Partner.find(params[:id])
    
    unless @parent_id == "0"
      @sub_to = " subcontractor to #{Partner.find(@parent_id).name}"
    end
    
    
    @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type(@job_id, @parent_id, @subcontractor.id, 1)
    unless @asg.nil?
      @log = @asg.logs
      @log.reverse!
      @log = @log[(0..3)]
      @log.each do |i|
        i.log_data = "#{i.target_type} #{i.target_name} #{i.action} on #{i.date} at #{i.time}"
      end
    else
      @log =  nil
    end
    
    if @subcontractor.contact_person.nil?
      @contact_person = ContactPerson.new(:name => "", :phone_number => "", :email => "") 
    else
      @contact_person = @subcontractor.contact_person
    end
    
  end

  def index
    @partners = Partner.find(:all)
  
  end
  
  def new
    
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
    @asg = Assignment.new
    @asg.job_id = params[:job_id]
    @asg.parent_id = params[:parent_id]
    @asg.partner_id  = params[:partner_id]
    @asg.partner_type = 1
    
    if params[:parent_id] == 0
      @job = Job.find(params[:job_id])
      @asg.logs.push(Log.new(:log_data =>"Added as subcontractor to job #{@job.job_number}/#{@job.name}"))
    else
      @asg.logs.create(Log.new(:log_data =>"Added as subcontractor to #{Partner.find(params[:parent_id]).name}"))
    end
    
    @asg.save
  end
  
  def add_item
    
    
  end
end
