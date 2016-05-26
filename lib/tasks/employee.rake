namespace :employee do
  task send_noty: :environment do
    require 'over'
    Over::MailgunMailer.send_msg
  end
end
