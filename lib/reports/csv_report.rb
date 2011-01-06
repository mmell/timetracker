module Reports
class CSVReport < Base # the name CSV conflicts with the CSV lib?

  MinuteColumn = 'D'
  MinuteTotalColumn = 'E'
  Columns = [
    'Activity',
    'Activity Completed',
    'Minutes',
    'Total Mins',
    'Total Hours',
    'Notes',
  ]

  def self.file_ext
    'csv'
  end
  
  def file_ext
    CSVReport.file_ext
  end
    
  def add_header_lines
    add_line( [
      'Dates', 
      "From #{@start_date.strftime('%Y-%m-%d')}", 
      "Until #{@end_date.strftime('%Y-%m-%d')}"
    ] )
    add_blank_line
    add_line( Columns ) 
  end
    
  def add_task_line(task)
    add_line( [
      project.name, 
      nil, 
      nil, 
      nil, 
      nil, 
      [project.url, project.description].delete_if { |e| e.blank? }.join(" : ")
    ] ) 
  end
  
  def add_task_totals_line(task)
    add_line( [
      nil, 
      'Task Total', 
      nil, 
      csv_sum_rows(MinuteColumn, @task_activity_row1, @current_row),
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
    add_line( ['Report generated at', Time.now.to_s] )
  end
  
  def initialize(start_date, end_date, activities)
    super(start_date, end_date, activities)
    add_header_lines

    task = nil
    activities.each { |activity|
      next if activity.minutes < 1
      if task != activity.task
        if !task.nil?
          # write the previous task's totals
          add_task_totals_line(task)
        end
        task = activity.task
        add_blank_line
        add_task_line(task)
        @task_activity_row1 = @current_row +1
      end

      add_activity_line(activity)
    } 
    add_task_totals_line(task) # totals for the last task need to be written

    add_final_totals_lines
  end
  
  def render
    @lines.map { |e| CSV.generate_line( e ) }.join('')
  end
  
end
end
