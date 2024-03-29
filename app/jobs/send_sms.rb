# -*- encoding : utf-8 -*-
class SendSms
  @queue = :send_sms

  def self.perform(id)
    SMS_LOGGER.debug "entering send_sms #{id}"
    return unless sn = SmsNotice.find_by_id(id)
    result, error_message = ::SmsSender.send_sms_to_mobile(sn.phone, sn.send_reason, sn.param)
    if result
      sn.sent!
      SMS_LOGGER.debug "send to #{sn.user.email} #{sn.phone} with #{sn.param}"
    else
      SMS_LOGGER.error error_message
    end
  end
end
