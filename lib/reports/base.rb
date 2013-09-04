module Reports
  class Base
    require 'csv'

    def initialize(start_date, end_date, project, user)
      @start_date, @end_date, @project, @user = start_date, end_date, project, user
      @lines, @current_row = [], 0
    end

    def file_ext
      self.class::FILE_EXT
    end

    def name
      ActiveSupport::Inflector.dasherize(ActiveSupport::Inflector.demodulize(self.class.name))
    end

    def file_name
      "#{@project.report_name}_#{name}_#{@start_date.strftime('%Y-%m-%d')}_to_#{@end_date.strftime('%Y-%m-%d')}.#{file_ext}"
    end

    def each_project_each_activity(project)
      each_activity(project)
      project.projects.each { |e| each_project_each_activity(e) }
    end

    def project_activities(project)
      Activity.includes(:project).order( "activities.stopped DESC").where( [
          # adding 1.day to end_date to include the final hours of the requested day
          "activities.minutes > 1 and stopped > ? and activities.stopped < ? and activities.project_id = ? and activities.person_id = ?",
          @start_date, @end_date + 1.day, project.id, @user.id
        ]).all
    end

    def csv_sum_rows(column, start_row, end_row)
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
