module ApplicationHelper
  include HelperUtils
  def up_or_down(u)
    u == "up" ? "涨" : "跌"
  end
end
