module HelperUtils
  def float_to_int(float)
    return 0 if float.nil?
    float * 1000000 / 100
  end

  def int_to_float(int)
    return 0.0 if int.nil?
    int / 10000.0
  end

  def odds_in_percentage
    "%d%" % (Settings.odds * 100)
  end

  def open_at_code(open_at)
    Time.at(open_at).strftime("%Y%m%H%M")
  end
end
