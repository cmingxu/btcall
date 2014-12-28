module ApplicationHelper
  include HelperUtils
  def up_or_down(u)
    u == "up" ? "看涨" : "看跌"
  end
end
