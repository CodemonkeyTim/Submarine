class PartnerController < ApplicationController
  def show
    @title = "Partner details"
    @partner = Partner.find(params[:id])
  end
end
