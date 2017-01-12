class ApplicationController < ActionController::Base
  require 'dgp_module'
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :update_spot_price

  private
  def update_spot_price
    DGP::MarketData.update_usd_btc_spot_price
  end
  
end
