module Reports
  require 'reports/base.rb'
  require 'reports/activity_detail.rb'
  require 'reports/project_summary.rb'
  require 'reports/daily.rb'
 
  Formats = [
    ['Activity Detail', 'ActivityDetail'],
    ['Project Summary', 'ProjectSummary'],
    ['Daily Activity', 'Daily'],
  ]
      
end
