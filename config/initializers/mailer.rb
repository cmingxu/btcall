ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  :address => "smtp.163.com",
  :port => 25,
  :domain => "163.com",
  :user_name => "admin@btcall.com",
  :password => "btc2014",
  :authentication => :login
}

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.default_url_options = { host: Settings.host }
ActionMailer::Base.logger = MAIL_LOGGER
