class HistoriesController < ApplicationController
  
  #Pulls all the log data of a job or an assignment, depending on the given partner_type, for the view 
  def show
    #The job version includes also the logs of the assignments in the job 
    if params[:partner_type] == "0"
      @job = Job.find(params[:job_id])
      
      @assignments = Assignment.find_all_by_job_id(@job.id)
      @asg_loggings = @assignments.collect {|i| i.logs}.flatten
      @loggings = @job.logs + @asg_loggings 
      @loggings.sort_by! {|i| i.created_at }
      @loggings.reverse!
      
      @loggings.each do |i|
        if i.loggable_type == "Assignment"
          @id = Assignment.find(i.loggable_id).partner_id
          @partner = Partner.find(@id)
          i.log_data = "#{@partner.name}: #{i.log_data}"
        end
      end
      @logs = @loggings
      @title_text = "#{@job.job_number} #{@job.name}"
    else
      @asg = Assignment.find_by_job_id_and_parent_id_and_partner_id_and_partner_type(params[:job_id], params[:parent_id], params[:partner_id], params[:partner_type])
      @partner = Partner.find(@asg.partner_id)
      @logs = @asg.logs.sort_by! {|i| i.created_at }.reverse
      @job = Job.find(@asg.job_id)
      @title_text = "#{@job.job_number} #{@job.name}"
      @title_text_vendor = "#{@partner.name}"
    end
  end
end
