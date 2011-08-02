class SuppliersController < ApplicationController
  def show
    @job_id = params[:job_id]
    @parent_id = params[:parent_id]
    
    @supplier = Partner.find(params[:id])
    @job = Job.find(params[:job_id])
    @subcontractor = Partner.find(params[:subcontractor_id])
    
    @log = @supplier.log_markings
    
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
        
    File.open("~/rails/Submarine/log/history_logs/#{params[:name]}-in-#{params[:job_number]}-for-#{Subcontractor.find(params[:id]).name}.log", 'w') do |i|
      i.write("Supplier assigned to #{Subcontractor.find(params[:id]).name} at #{Time.now}")
    end
  end
  
  def create
    
  end
end
