module IndexHelper
  
  def get_list_items partner_id, job_number 
    @partner_partner_data = JobPartnerPartner.find_all_by_partner_id_and_job_number(partner_id, job_number)
    
    @partner_ids = []
    @list_items = []
    
    @partner_partner_data.each do |i|
      @partner_ids.push(i.p_partner_id)
    end    
    
    @partner_ids.each do |i|
      @items = ListItem.find_all_by_partner_id_and_job_number(i, job_number, :order => "TRIM(LOWER(state))")
      @items.each do |j|
        @list_items.push(j)  
      end
    end
    
    return @list_items
  end
  
  def get_worst_overdues
    @returnable = []
    
    @items = ListItem.find_all_by_state(1)
    
    @items.each do |i| 
      @job_name = Job.find_by_job_number(i.job_number).name
      @data = [i.job_number] 
      @data.push(@job_name)
      @data.push(Partner.find(i.id).name)
      @data.push(i.item_data)
      @data.push(((Time.now.utc - 864000 - i.touched_at)/60/60/24).to_i)
      @returnable.push(@data)
    end
       
    return @returnable
  end  
  
end
