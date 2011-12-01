class SubcontractorsController < ApplicationController
  
  #A View Action
  def show     
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    
    @job = Job.find(@job_id)
    @subcontractor = Partner.find(params[:id])
    
    #Fetching the documents of the sub
    @documents = Assignment.find_all_by_job_id_and_partner_id_and_parent_id_and_partner_type(@job.id, @subcontractor.id, @parent_id, 1).collect {|i| i.documents }.flatten
    
    unless @parent_id == "0"
      @sub_to = " subcontractor to #{Partner.find(@parent_id).name}"
    end
    
    #Saving formatted log data into non-persistent var log_data
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
    
    #For showing purposes an "empty" contact person is created if none exists
    if @subcontractor.contact_person.nil?
      @contact_person = ContactPerson.new() 
    else
      @contact_person = @subcontractor.contact_person
    end
    
    #Same with the address
    if @subcontractor.address.nil?
      @address = Address.new() 
    else
      @address = @subcontractor.address
    end
    
  end
  
  #A View/Ajax Action
  #For each payment tab, this and it's corresponding view are loaded without changing the surroundings.
  def sub_in_payment
    @payment = Payment.find(params[:payment_id])
    @subcontractor = Partner.find(params[:id])
    @job = @payment.job
    @asg = @payment.assignments.find_by_partner_id(@subcontractor.id)
    @parent_id = @asg.parent_id
    
    render :layout => nil
  end
  
  #A View/Ajax Action
  #Lists all the subcontractors of a job
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
end
