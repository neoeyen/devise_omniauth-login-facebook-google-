class HomeController < ApplicationController
  before_action :ensure_signup_complete
  
  def index
  end
end
