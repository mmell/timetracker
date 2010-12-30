class Reports::CSV
  require 'csv'

  FirstTaskRow = 5
  FirstActivityRow = 6

  def CSV.csv_sum_rows(column, start_row, row_ct)
    column.upcase!
    end_row = start_row + row_ct
    %Q{=SUM(#{column}#{start_row}:#{column}#{end_row})}
  end
  
  def generate_blank_line
    @data << CSV.generate_line([''])  
  end
    
  def initialize(start_date, end_date, activities)
    @data = []

    columns = [
      'Objective',
      'Task',
      'Activity Completed',
      'Total Hours',
      'Minutes',
      'Total Mins',
      'Notes',
    ]
    @data << CSV.generate_line( ['Dates', "From #{start_date.strftime('%Y-%m-%d')}", "Until #{end_date.strftime('%Y-%m-%d')}"] )
    generate_blank_line
    @data << CSV.generate_line( columns ) 

    activity_rows = 0
    task = nil
    activities.each { |activity|
      next if activity.minutes < 1 
      if task != activity.task
        task = activity.task
        generate_blank_line
        @data << CSV.generate_line( [task.objective.name, task.name, nil, task.hours, nil, task.minutes, task.objective.url] ) 
        activity_rows += 2
      end

      # activity row
      @data << CSV.generate_line([nil, nil, activity.local_stop_time, nil, activity.minutes, nil, activity.description]) 
      activity_rows += 1
    } 

    generate_blank_line
    generate_blank_line
    @data << CSV.generate_line( ['Total', nil, nil, CSV.csv_sum_rows('D', FirstTaskRow, activity_rows), nil, CSV.csv_sum_rows('E', FirstActivityRow, activity_rows)] )
    generate_blank_line
    @data << CSV.generate_line( ['Document created at', Time.now.to_s] )
  end
  
  def render
    @data.join('')
  end
  
end
