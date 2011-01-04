module Reports
  require 'reports/base.rb'
  require 'reports/csv_report.rb'
  require 'reports/task_summary.rb'
  require 'reports/daily.rb'
 
  Formats = [
    ['CSV', 'CSVReport'],
    ['Daily Activity', 'Daily'],
    ['Task Summary', 'TaskSummary'],
  ]
      
end
