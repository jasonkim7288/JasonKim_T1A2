require 'tty-table'
require_relative 'mail_constant'

class Account
    attr_accessor :name
    attr_reader :file_name
    def initialize (file_name = MailConstant::FILE_NAME_ACCOUNT)
        @file_name = file_name 
        @name = File.read(@file_name).split
    end

    def remove(name)
        @name.delete(name)
        File.write(@file_name, @name.join("\n"))
    end

    def add(name)
        if !@name.include?(name)
            @name.push(name)
            File.write(@file_name, @name.join("\n"))
        end
    end

    def to_string
        if @name.empty?
            return "   #{MailConstant::STR_ACCOUNT_LIST_EMPTY}"
        end
        table = TTY::Table.new header: [{value: "No.", alignment: :center}, {value: "Account name", alignment: :center}]
        @name.each_with_index {|account, index| table << [{value: index + 1, alignment: :center}, account]}
        return table.render(:unicode, column_widths: [9, 71], padding: [1, 1]) {|renderer| renderer.border.separator = :each_row}
    end
end
