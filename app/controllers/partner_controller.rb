class PartnerController < ApplicationController
  def show
    @partner = Partner.find(params[:id])
    
    @job_number_data_of_partner = JobPartner.find_all_by_partner_id(@partner.id)
    @job_number_data_of_partner2 = JobPartnerPartner.find_all_by_p_partner_id(@partner.id)
    
    @job_numbers = []
    
    @job_number_data_of_partner.each do |i|
      @job_numbers.push(i.job_number)
    end
     
    @job_number_data_of_partner2.each do |i|
      @job_numbers.push(i.job_number)
    end
     
    @jobs = Job.find_all_by_job_number(@job_numbers)
     
  end
end
