module Reports
  class ActivityDetail < Base

    FILE_EXT = 'csv'
    MinuteColumn = 'C'
    MinuteTotalColumn = 'D'
    Columns = [
      'Project',
      'Activity Completed',
      'Minutes',
      'Total Mins',
      'Total Hours',
      'Comments/Notes',
    ]

    def initialize(start_date, end_date, project, user)
      super(start_date, end_date, project, user)
      add_header_lines

      @current_project = nil # tracking sub-projects
      project_rows(@project)
      add_project_totals_line(@current_project) # totals for the last sub-project need to be written

      add_final_totals_lines
    end

    def project_rows(project)
      project_activities(project).each { |activity|
        if @current_project != activity.project
          if !@current_project.nil?
            # write the previous sub-project's totals
            add_project_totals_line(@current_project)
          end
          @current_project = activity.project
          add_blank_line
          add_project_line(@current_project)
          @sub_project_activity_row1 = @current_row +1
        end

        add_activity_line(activity)
      }
      project.projects.each { |e| project_rows(e) }
    end

    def add_header_lines
      add_line( [
        'Dates',
        "From #{@start_date.strftime('%Y-%m-%d')}",
        "Through #{@end_date.strftime('%Y-%m-%d')}"
      ] )
      add_blank_line
      add_line( Columns )
    end

    def add_project_line(project)
      add_line( [
        project.name,
        nil,
        nil,
        nil,
        nil,
        [project.url, project.description].delete_if { |e| e.blank? }.join(" : ")
      ] )
    end

    def add_project_totals_line(project)
      add_line( [
        nil,
        'SubTotal',
        nil,
        csv_sum_rows(MinuteColumn, @sub_project_activity_row1, @current_row),
        %Q{=(#{MinuteTotalColumn}#{@current_row +1}/60.0)}
      ] )
    end

    def add_activity_line(activity)
      add_line( [
        nil,
        activity.local_stop_time,
        activity.minutes,
        nil,
        nil,
        activity.description.to_s.strip # FIXME .to_s.strip unnecessary in upcoming release
      ])
      @activity_row1 ||= @current_row
    end

    def add_final_totals_lines()
      add_blank_line
      add_blank_line
      add_line( [
        'Total',
        nil,
        nil,
        csv_sum_rows(MinuteColumn, @activity_row1, @current_row -3),
        %Q{=(#{MinuteTotalColumn}#{@current_row +1}/60.0)}
      ] )
      add_blank_line
      add_line( [nil, nil, nil, nil, 'Report', file_name] )
      add_line( [nil, nil, nil, nil, 'Generated at', Time.now.to_s] )
    end

    def render
      @lines.map { |e| CSV.generate_line( e ) }.join('')
    end

  end
end
