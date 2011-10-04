class DocumentsController < ApplicationController
  def new
    if params[:owner_type] == "job"
      @owner = Job.find(params[:id])
      @owner_name = @owner.name
      @owner_type = 1
    end
    if params[:owner_type] == "" || params[:owner_type].nil?
      @payment = Payment.find(params[:payment_id])
      @owner = Assignment.find_by_job_id_and_partner_id_and_partner_type_and_parent_id_and_payment_id(@payment.job_id, params[:id], params[:partner_type], params[:parent_id], @payment.id)
      @owner_name = Partner.find(@owner.partner_id).name
      @owner_type = 2
    end
  end
  
  def edit
  end
  
  def create
    @owner
    @owner_id = params[:owner_id]
    @owner_type = params[:owner_type]
    
    @page_to_return_to = ""
    
    if @owner_type == "1" || @owner_type == 1
      @owner = Job.find(@owner_id)
      @page_to_return_to = "/jobs/#{@owner.id}"
    end
    
    if @owner_type == "2" || @owner_type == 2
      @owner = Assignment.find(@owner_id)
      if @owner.partner_type == 1
        @page_to_return_to = "/subcontractors/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      else
        @page_to_return_to = "/suppliers/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}&payment_id=#{params[:payment_id]}"
      end
    end
    
    @owner.documents.push(Document.new(:name => params[:document_name]))
    @doc = @owner.documents.last
    @doc.document = params[:document]
    @doc.save

    @owner.logs.create(:target_type => "Document", :target_name => params[:name], :action => "added", :time => get_time, :date => get_date)
  end
  
  def delete
    @doc = Document.find(params[:id])
    @doc.delete
  end
end
