class HistoriesController < ApplicationController
  def show
    if params[:partner_type] == "0"
      @job = Job.find(params[:job_id])
      @logs = @job.logs.sort_by! {|i| i.created_at}.reverse
      @title_text = "#{@job.job_number} / #{@job.name}"
    else
      @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type(params[:job_id], params[:parent_id], params[:partner_id], params[:partner_type])
      @partner = Partner.find(@asg.partner_id)
      @logs = @asg.logs.sort_by! {|i| i.created_at}.reverse
      @job = Job.find(@asg.job_id)
      @title_text = "#{@partner.name} in #{@job.job_number} / #{@job.name}" 
    end
  end
end
