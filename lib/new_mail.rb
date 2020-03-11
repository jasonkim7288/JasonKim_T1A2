class NewMail
    attr_accessor :mail_to, :mail_subject, :mail_body

    def initialize(gmail)
        @gmail = gmail
        @mail_to = ""
        @mail_subject = ""
        @mail_body = ""
    end

    def send
        mail_to = @mail_to
        mail_subject = @mail_subject
        mail_body = @mail_body
        @gmail.deliver do
            to mail_to
            subject mail_subject
            html_part do
                content_type 'text/html; charset=UTF-8'
                body mail_body
            end
        end
    end
end