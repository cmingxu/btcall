module HelperUtils
  def float_to_int(float)
    return 0 if float.nil?
    float * 10000 / 100
  end

  def int_to_float(int)
    return 0.0 if int.nil?
    int / 100.0
  end

  def odds_in_percentage
    "%d%" % (Settings.odds * 100)
  end
end
