# -*- encoding : utf-8 -*-
class Sleeper
  @queue = :sleep

  def self.perform
    BG_LOGGER.debug "1" * 100
  end
end
