module Reports
  require 'reports/base.rb'
  require 'reports/csv_report.rb'
  require 'reports/activity_summary.rb'
  require 'reports/daily.rb'
 
  Formats = [
    ['Activity Detail', 'ActivityDetail'],
    ['Project Summary', 'ProjectSummary'],
    ['Daily Activity', 'Daily'],
  ]
      
end
