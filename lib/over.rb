module Over
  class MailgunMailer
    def self.send_msg attachments=[]
      require 'mailgun'

      mg_client = Mailgun::Client.new('key-767yiuhhiy7yiuhkjh7767868')
      mb_obj = Mailgun::MessageBuilder.new()

      mb_obj.set_from_address("informer@systemofbusiness.ru", {"first"=>"ISB", "last" => "INFORMER"});
      mb_obj.add_recipient(:to, "holm-van@narod.ru");
      mb_obj.add_recipient(:cc, "zhukov@systemofbusiness.ru");
      mb_obj.set_subject("Пора вносить вакансии");

      user = User.find_by email: 'holm-van@narod.ru'
      u = user.authentication_token
           
      mb_obj.set_text_body("Доброго утра и хорошего дня! Пора обновить количество вакансий.
        Перейдите по ссылке: http://localhost:3000/vacancies?user_email=holm-van@narod.ru&user_token=#{u}");


      attachments.each do |attachment|
        mb_obj.add_attachment(attachment[:file_path], attachment[:title]);
      end

      result = mg_client.send_message("sandbox07f934720fee40bdb84fc954b156a9d9.mailgun.org", mb_obj)

    end
  end
end
