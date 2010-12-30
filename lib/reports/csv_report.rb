module Reports
class CSVReport # the name CSV conflicts with the CSV lib?
  require 'csv'

  MinuteColumn = 'D'
  MinuteTotalColumn = 'E'
  Columns = [
    'Objective',
    'Task',
    'Activity Completed',
    'Minutes',
    'Total Mins',
    'Total Hours',
    'Notes',
  ]

  def self.csv_sum_rows(column, start_row, end_row)
    column.upcase!
    %Q{=SUM(#{column}#{start_row}:#{column}#{end_row})}
  end
  
  def generate_line( columns )
    @current_row += 1
    @data << CSV.generate_line( columns )
  end
  
  def generate_blank_line
    generate_line([''])  
  end
    
  def generate_header_lines(start_date, end_date)
    generate_line( [
      'Dates', 
      "From #{start_date.strftime('%Y-%m-%d')}", 
      "Until #{end_date.strftime('%Y-%m-%d')}"
    ] )
    generate_blank_line
    generate_line( Columns ) 
  end
    
  def generate_task_line(task)
    generate_line( [
      task.objective.name, 
      task.name, 
      nil, 
      nil, 
      nil, 
      nil, 
      task.objective.url
    ] ) 
  end
  
  def generate_task_totals_line(task)
    generate_line( [
      nil, 
      nil, 
      'Task Total', 
      nil, 
      CSVReport.csv_sum_rows(MinuteColumn, @task_activity_row1, @current_row),
      %Q{=(#{MinuteTotalColumn}#{@current_row +1}/60.0)} 
    ] )
  end
  
  def generate_activity_line(activity)
    generate_line( [
      nil, 
      nil, 
      activity.local_stop_time, 
      activity.minutes, 
      nil, 
      nil, 
      activity.description.to_s.strip # FIXME .to_s.strip unnecessary in upcoming release
    ])
    @activity_row1 ||= @current_row
  end
  
  def generate_final_totals_lines()
    generate_blank_line
    generate_blank_line
    generate_line( [
      'Total', 
      nil, 
      nil, 
      nil, 
      CSVReport.csv_sum_rows(MinuteColumn, @activity_row1, @current_row -2), 
      %Q{=(#{MinuteTotalColumn}#{@current_row +1}/60.0)}
    ] )
    generate_blank_line
    generate_line( ['Report generated at', Time.now.to_s] )
  end
  
  def initialize(start_date, end_date, activities)
    @data = []
    @current_row = 0

    generate_header_lines(start_date, end_date)

    task = nil
    activities.each { |activity|
      next if activity.minutes < 1
      if task != activity.task
        if !task.nil?
          # write the previous task's totals
          generate_task_totals_line(task)
        end
        task = activity.task
        generate_blank_line
        generate_task_line(task)
        @task_activity_row1 = @current_row +1
      end

      generate_activity_line(activity)
    } 

    generate_final_totals_lines
  end
  
  def render
    @data.join('')
  end
  
end
end
