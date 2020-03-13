class NewMail
    attr_accessor :to, :subject, :body, :attach

    def initialize(gmail)
        @gmail = gmail
        @to = ""
        @subject = ""
        @body = ""
        @attach = ""
    end

    def send(want_to_attach)
        mail_to = @to
        mail_subject = @subject
        mail_body = @body
        mail_attach = @attach

        if @attach != "" && File.exist?(@attach)
            @gmail.deliver do
                to mail_to
                subject mail_subject
                html_part do
                    content_type 'text/html; charset=UTF-8'
                    body mail_body
                end
                add_file mail_attach
            end
        else
            puts "Failed to load the file, but sending it anyway" if want_to_attach
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
end