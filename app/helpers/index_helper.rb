module IndexHelper
  def get_list_items partner_id, job_number 
    @partner_partner_data = JobPartnerPartner.find_all_by_partner_id_and_job_number(partner_id, job_number)
    
    @partner_ids = []
    @list_items = []
    
    @partner_partner_data.each do |i|
      @partner_ids.push(i.p_partner_id)
    end    
    
    @partner_ids.each do |i|
      @items = ListItem.find_all_by_partner_id_and_job_number(i, job_number)
      @items.each do |j|
        @list_items.push(j)  
      end
    end
    
    return @list_items
  end
end
