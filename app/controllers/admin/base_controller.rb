class Admin::BaseController < ApplicationController
  layout "admin"
  before_filter :admin_required

  def index
  end
end
