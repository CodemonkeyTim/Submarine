class DocumentsController < ApplicationController
  
  #Pulls the information needed in the upload view
  def new
    #Varible values if the file to be uploaded will be attached to a job
    if params[:owner_type] == "job"
      @owner = Job.find(params[:id])
      @owner_name = @owner.name
      @owner_type = 1
    end
    #Same for sub/sup
    if params[:owner_type] == "" || params[:owner_type].nil?
      @payment = Payment.find(params[:payment_id])
      @owner = Assignment.find_by_job_id_and_partner_id_and_partner_type_and_parent_id_and_payment_id(@payment.job_id, params[:id], params[:partner_type], params[:parent_id], @payment.id)
      @owner_name = Partner.find(@owner.partner_id).name
      @owner_type = 2
    end
  end
  
  #Redundant?
  def edit
    
  end
  
  #Creates a Document record with the data from the views and links it to a Job record or Assignment record
  def create
    @owner
    @owner_id = params[:owner_id]
    @owner_type = params[:owner_type]
    
    #The redirect url string
    @page_to_return_to = ""
    
    #Owner type 1 means that document will be attached to a job
    if @owner_type == "1" || @owner_type == 1
      @owner = Job.find(@owner_id)
      @page_to_return_to = "/jobs/#{@owner.id}"
    end
    
    #And owner type 2 means sub/supplier
    if @owner_type == "2" || @owner_type == 2
      @owner = Assignment.find(@owner_id)
      
      #If it was sub, the redirect url is a lil bit different
      if @owner.partner_type == 1
        @page_to_return_to = "/subcontractors/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}"
      else
        @page_to_return_to = "/suppliers/#{@owner.partner_id}?job_id=#{@owner.job_id}&parent_id=#{@owner.parent_id}&payment_id=#{params[:payment_id]}"
      end
    end
    
    @owner.documents.push(Document.new(:name => params[:document_name]))
    @doc = @owner.documents.last
    @doc.document = params[:document] #This is the data received from the input which is of type "file"
    @doc.save
    
    #For grande finale, a log mark is created of document attachment
    @owner.logs.create(:target_type => "Document", :target_name => params[:document_name], :action => "added", :time => get_time, :date => get_date)
  end
  
  #Deletes a document in given id and creates a log mark
  def delete
    @doc = Document.find(params[:id])
    if @doc.owner_type == "Job"
      @owner = Job.find(@doc.owner_id)
    end
    if @doc.owner_type == "Assignment"
      @owner = Assignment.find(@doc.owner_id)
    end
    @owner.logs.create(:target_type => "Document", :target_name => @doc.name, :action => "deleted", :time => get_time, :date => get_date)
    @doc.delete
  end
end
