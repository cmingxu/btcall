class Dashboard::BaseController < ApplicationController
  layout "dashboard"
  before_filter :login_required

  def index
  end
end
