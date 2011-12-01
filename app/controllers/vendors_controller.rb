class VendorsController < ApplicationController
  
  #A View Action
  #Lists all the vendors/partners in alphabetical order
  def index
    @vendors  = Partner.find(:all, :order => "name")
    
  end

  #A View Action
  #Show a single vendor/partner
  def show
    @vendor = Partner.find(params[:id])
    @assignments = Assignment.find_all_by_partner_id(params[:id])
    
    #If not contact person exists, then "empty" contact person is created
    if @vendor.contact_person.nil?
      @contact_person = ContactPerson.new() 
    else
      @contact_person = @vendor.contact_person
    end
    
    #Same as above for address
    if @vendor.address.nil?
      @address = Address.new() 
    else
      @address = @vendor.address
    end
    
    #All the jobs where vendor is present
    @jobs = Job.find_all_by_id(@assignments.collect {|i| i.job_id}.flatten)
  end
  
  def new
    
  end
  
  #A Background Action
  def create
     @partner = Partner.create(:name => params[:partner_name])
     
     @partner.contact_person = ContactPerson.create(:name =>params[:cp_name], :title => params[:cp_title], :phone_number => params[:cp_phone_number], :email => params[:cp_email])
     @partner.address = Address.create(:street => params[:addrs_street], :zip_code => params[:addrs_zip_code], :city => params[:addrs_city], :state => params[:addrs_state])   
  end
  
  #A View Action
  #Show the vendor edit page
  def edit
    @partner = Partner.find(params[:id])
    
    if @partner.contact_person.nil?
      @cp = ContactPerson.new(:partner_id => 0, :name => "", :title => "", :phone_number => "", :email => "")
    else
      @cp = @partner.contact_person
    end
    
    if @partner.address.nil?
      @addrs = Address.new(:partner_id => 0, :street => "", :city => "", :zip_code => 0, :state => "")  
    else
      @addrs = @partner.address
    end
  end
  
  #A Background Action
  #Edits a vendor according to params given and saves it
  def update
    @partner = Partner.find(params[:id])
    
    @partner.name = params[:partner_name]
    @partner.save
    
    @addrs = @partner.address
    
    unless @addrs.nil?
      @addrs.street = params[:addrs_street]
      @addrs.zip_code = params[:addrs_zip_code]
      @addrs.city = params[:addrs_city]
      @addrs.state = params[:addrs_state]
      @addrs.save
    else
      @addrs = Address.new
      @addrs.street = params[:addrs_street]
      @addrs.zip_code = params[:addrs_zip_code]
      @addrs.city = params[:addrs_city]
      @addrs.state = params[:addrs_state]
      @addrs.save
      @partner.address = @addrs
    end
    
    @cp = @partner.contact_person
    
    unless @co.nil?
      @cp.name = params[:cp_name]
      @cp.title = params[:cp_title]
      @cp.phone_number = params[:cp_phone_number]
      @cp.email = params[:cp_email]
      @cp.save
    else
      @cp = ContactPerson.new
      @cp.name = params[:cp_name]
      @cp.title = params[:cp_title]
      @cp.phone_number = params[:cp_phone_number]
      @cp.email = params[:cp_email]
      @cp.save
      @partner.contact_person = @cp
    end
    
    if params[:partner_type] == "1"
      @page_to_return_to = "subcontractors/#{@partner.id}?job_id=#{params[:job_id]}&parent_id=#{params[:parent_id]}"
    end
    
    if params[:partner_type] == "2"
      @page_to_return_to = "suppliers/#{@partner.id}?job_id=#{params[:job_id]}&&parent_id=#{params[:parent_id]}"
    end
    
    if params[:partner_type].nil? || params[:partner_type] == "" 
      @page_to_return_to = "vendors/#{@partner.id}"
    end
    
  end


end
