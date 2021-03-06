class SubcontractorsController < ApplicationController
  def show     
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    
    @job = Job.find(@job_id)
    @subcontractor = Partner.find(params[:id])
    
    @documents = Assignment.find_all_by_job_id_and_partner_id_and_parent_id_and_partner_type(@job.id, @subcontractor.id, @parent_id, 1).collect {|i| i.documents }.flatten
    
    unless @parent_id == "0"
      @sub_to = " subcontractor to #{Partner.find(@parent_id).name}"
    end
    
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
      @contact_person = ContactPerson.new() 
    else
      @contact_person = @subcontractor.contact_person
    end
    
    if @subcontractor.address.nil?
      @address = Address.new() 
    else
      @address = @subcontractor.address
    end
    
  end
  
  def sub_in_payment
    @payment = Payment.find(params[:payment_id])
    @subcontractor = Partner.find(params[:id])
    @job = @payment.job
    @asg = @payment.assignments.find_by_partner_id(@subcontractor.id)
    @parent_id = @asg.parent_id
    
    render :layout => nil
  end

  def index
    @partners = Partner.find(:all)
  
  end
  
  def create
    
  end
  
  def create_address
    
  end

  def create_contact
    
  end
  
  def all_subs
    @job = Job.find(params[:id])
    @payments = Payment.find_all_by_job_id(@job.id)
    
    @asgs = @payments.collect {|i| i.assignments }.flatten
    @asgs2 = []
    @asgs.each do |i|
      if i.partner_type == 1 && i.parent_id == 0
        @asgs2.push(i)
      end
    end
    
    @ids = @asgs2.collect {|i| i.partner_id }.flatten
    @ids = @ids.uniq.sort
    
    @subs = Partner.find(@ids)
    
    render :layout => nil
  end
  
  def sort
    
  end
  
  def add_item
    
    
  end
end
