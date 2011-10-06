class SuppliersController < ApplicationController
  def show
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    @payment = Payment.find(params[:payment_id])
    
    @supplier = Partner.find(params[:id])
    @job = Job.find(params[:job_id])
    @subcontractor = Partner.find(params[:parent_id])
    
    @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type_and_payment_id(@job_id, @parent_id, @supplier.id, 2, @payment.id)
    
    @documents = Assignment.find_all_by_job_id_and_partner_id_and_parent_id_and_partner_type(@job.id, @supplier.id, @parent_id, 2).collect {|i| i.documents }.flatten
    
    unless @asg.nil?
      @log = @asg.logs
      @log.reverse!
      @log = @log[(0..3)]
      @log.each do |i|
        i.log_data = "#{i.target_type} #{i.target_name} #{i.action} on #{i.date} at #{i.time}"
      end
    else
      @log = nil
    end
    
    if @supplier.contact_person.nil?
      @contact_person = ContactPerson.new()
    else
      @contact_person = @supplier.contact_person
    end
    
    if @supplier.address.nil?
      @address = Address.new() 
    else
      @address = @supplier.address
    end
    
  end

  def index

  end
  
end
