class ApplicationMailer < ActionMailer::Base
  default from: "no-reply@sushi-counter.com"
  layout "mailer"
end
