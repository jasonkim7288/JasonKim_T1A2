require 'gmail'
require 'html_massage'

require_relative 'mail_constant'

class GmailManager
    attr_accessor :mail_labels, :current_mail_label, :mail_labels_array, :current_page, :total_page, :mailbox, :start_index, :end_index, :current_mail_index

    def initialize(gmail)
        @gmail = gmail
        @current_page = 1
        @total_page = 1
        load_mail_labels

        if ARGV.include?("-n")
            is_there_int = false
            int_value = 0
            count = 0
            ARGV.each do |argv|
                temp_value = argv.to_i
                if temp_value.to_s == argv
                    int_value = temp_value
                    count += 1
                end
            end
            if count == 1 && int_value >= 1 && int_value <= 50
                @num_of_rows_mail_list = int_value
            else
                @num_of_rows_mail_list = MailConstant::NUM_OF_ROWS_PREVIEW
            end
        else
            @num_of_rows_mail_list = MailConstant::NUM_OF_ROWS_PREVIEW
        end
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
    
    def load_mail_box
        @mailbox = @gmail.mailbox(@mail_labels[@current_mail_label]).emails(:all).reverse!
        @total_page = @mailbox.length / @num_of_rows_mail_list + 1
        @current_page = @total_page if @current_page > @total_page
        @start_index = ((@current_page - 1) * @num_of_rows_mail_list)
        @end_index = @current_page * @num_of_rows_mail_list > @mailbox.length ? @mailbox.length - 1 : @current_page * @num_of_rows_mail_list - 1
    end

    def mail_list_to_string
        return MailConstant::STR_MAILBOX_EMPTY if @mailbox.length == 0
        
        table_mail_list = TTY::Table.new header: [{value: "No", alignment: :center}, {value: "From", alignment: :center}, {value: "Content", alignment: :center}]
        for index in (@start_index..@end_index) do
            str_from = @mailbox[index].message.from ? (@mailbox[index].message.from.to_s.delete "[" "]" "\"") : ""
            str_subject = @mailbox[index].message.subject != nil ? @mailbox[index].message.subject.to_s : ""
            str_body = @mailbox[index].message.body != nil ? @mailbox[index].message.body.to_s : ""
            str_body = HtmlMassage.text(str_body)
            str_content = "#{str_subject} - #{str_body}".slice(0, MailConstant::COLUMN_MAIL_LIST_CONTENT_SIZE).delete("\n")
            table_mail_list << [{value: index + 1, alignment: :center}, str_from, str_content]
        end
        return table_mail_list.render(:unicode, column_widths: [MailConstant::COLUMN_MAIL_LIST_NO_SIZE, MailConstant::COLUMN_MAIL_LIST_FROM_SIZE, MailConstant::COLUMN_MAIL_LIST_CONTENT_SIZE], multiline: true, padding: [0, 1]) {|renderer| renderer.border.separator = :each_row}
    end

    def goto_prev_page
        @current_page -= 1 if @current_page > 1
    end

    def goto_next_page
        @current_page += 1 if @current_page < @total_page
    end

    def pages_info_to_string
        table_pages = TTY::Table.new [{value: "<< #{@current_page} / #{@total_page} >>", alignment: :center}], [['']]
        return table_pages.render(:basic, column_widths: [MailConstant::COLUMN_CENTER_WIDTH])
    end

    def mail_detail_to_string
        return "Mailbox is empty" if @mailbox.length == 0
        return "Mail content is empty" if mailbox[@current_mail_index] == nil
        str_from = @mailbox[@current_mail_index].message.from != nil ? (@mailbox[@current_mail_index].message.from.to_s.delete "[" "]" "\"") : ""
        str_subject = @mailbox[@current_mail_index].message.subject != nil ? @mailbox[@current_mail_index].message.subject.to_s : ""
        str_body = @mailbox[@current_mail_index].message.body != nil ? @mailbox[@current_mail_index].message.body.to_s.slice(0, MailConstant::COLUMN_MAIL_DETAIL_CONTENT_SIZE * 30) : ""
        str_body = HtmlMassage.text(str_body)

        table = TTY::Table.new header: [{value: "From", alignment: :center}, {value: str_from}],
                                rows: [[{value: "Subject", alignment: :center}, {value: str_subject}],
                                        [{value: "Body", alignment: :center}, {value: str_body}]]
        return table.render(:unicode, column_widths: [MailConstant::COLUMN_MAIL_DETAIL_HEADER_SIZE, MailConstant::COLUMN_MAIL_DETAIL_CONTENT_SIZE], multiline: true, padding: [0, 1]) do |renderer|
            renderer.border.separator = :each_row
        end
    end
end