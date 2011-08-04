class AssignmentsController < ApplicationController
  def new
    
    @partners = Partner.all
    
    @parent_id = params[:parent_id]
    @job = Job.find(params[:job_id])
    @partner_type = params[:partner_type]
    
    if params[:parent_id] == "0"
      @title_text = "Assign subcontractor to #{@job.job_number} / #{@job.name}"
    else
      if params[:partner_type] == "1"
        @what_to_assign = "subcontractor"
        @target_name = Partner.find(params[:parent_id]).name
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
      if params[:partner_type] == "2"
        @what_to_assign = "supplier"
        @target_name = Partner.find(params[:parent_id]).name
        @title_text = "Assign #{@what_to_assign} to #{@target_name}"
      end
    end
  end

  def create
    Assignment.create(:job_id => params[:job_id], :parent_id => params[:parent_id], :partner_id => params[:partner_id], :partner_type => params[:partner_type])
  end

end
