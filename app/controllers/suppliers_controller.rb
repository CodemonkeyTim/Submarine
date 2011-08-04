class SuppliersController < ApplicationController
  def show
    @job_id = params[:job_id]
    @parent_id = params[:subcontractor_id]
    
    @supplier = Partner.find(params[:id])
    @job = Job.find(params[:job_id])
    @subcontractor = Partner.find(params[:subcontractor_id])
    
    @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type(@job_id, @parent_id, @supplier.id, 2)
    
    unless @asg.nil?
      @log = @asg.logs
      @log.reverse!
      @log = @log[(0..3)]
    else
      @log = nil
    end
    
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
    @asg = Assignment.new
    @asg.job_id = params[:job_id]
    @asg.parent_id = params[:parent_id]
    @asg.partner_id  = params[:partner_id]
    @asg.partner_type = 2
    
    @asg.logs.create(:log_data =>"Added as supplier to #{Partner.find(params[:parent_id]).name}")
    
    @asg.save
  end
  
  def create
    
  end
end
