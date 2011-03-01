module Reports
  require 'reports/base.rb'
  require 'reports/csv_report.rb'
  require 'reports/activity_summary.rb'
  require 'reports/daily.rb'
 
  Formats = [
    ['Activity Detail', 'CSVReport'],
    ['Project Summary', 'ActivitySummary'],
    ['Daily Activity', 'Daily'],
  ]
      
end
