module Reports
  class Base
    require 'csv'

    def initialize(start_date, end_date, activities)
      @start_date, @end_date = start_date, end_date
      @lines, @current_row = [], 0
    end

    def self.csv_sum_rows(column, start_row, end_row)
      column.upcase!
      %Q{=SUM(#{column}#{start_row}:#{column}#{end_row})}
    end

    def add_line( line_array )
      @current_row += 1
      @lines << line_array
    end

    def add_blank_line
      add_line([''])  
    end

    def format_hours(hours_float)
      "%6.2f" % [ hours_float ]
    end

  end
end
