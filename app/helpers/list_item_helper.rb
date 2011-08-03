module ListItemHelper
  
  def get_vendor_name(cli)  
    return Partner.find(Assignment.find(cli.assignment_id).partner_id).name
  end
  
  def get_job_details(cli)
    @job = Job.find(Assignment.find(cli.assignment_id).job_id)
    "#{@job.job_number} / #{@job.name}"
  end
  
end
