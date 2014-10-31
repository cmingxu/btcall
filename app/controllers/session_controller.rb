class SessionController < ApplicationController
  before_filter :no_login_required, :except => :logout

  def login
  end

  def register
  end

  def logout
  end
end
