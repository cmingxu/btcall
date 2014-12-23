class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_filter :login_required

  def index
    @active_nav_item = "chart"
  end
end
