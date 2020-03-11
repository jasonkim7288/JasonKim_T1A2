require 'gmail'

require_relative 'mail_constant'

class GmailManager
    attr_accessor :mail_labels, :current_mail_label, :mail_labels_array

    def initialize(gmail)
        @gmail = gmail
        load_mail_labels
    end

    def load_mail_labels
        @mail_labels = @gmail.labels.all.inject(Hash.new()) do |result, label|
            simple_label = label.gsub("[Gmail]/", "").gsub("[Gmail]", "")
            if simple_label != ""
                result[simple_label] = label
                @current_mail_label = simple_label if @current_mail_label == nil
            end
            result
        end
        @mail_labels_array = @mail_labels.inject([]) {|result, (key, value)| result.push(key);result}
    end

    def current_mail_label_to_string
        str_mail_labels = @mail_labels_array.inject("|") {|result, mail_label| result += ((result.length / 110 != (result.length + mail_label.length) / 110) ? "\n|" : "") +
                                                        "  #{(mail_label == @current_mail_label) ? (mail_label.red) : mail_label}  |"; result}
        table_pages = TTY::Table.new [{value: str_mail_labels, alignment: :center}], [['']]
        return table_pages.render(:basic, multiline: true, column_widths: [MailConstant::COLUMN_CENTER_WIDTH])
    end
end