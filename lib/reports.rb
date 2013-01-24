module Reports
  require 'reports/base.rb'
  require 'reports/activity_detail.rb'
  require 'reports/activity_each.rb'
  require 'reports/project_summary.rb'
  require 'reports/project_summary_description.rb'
  require 'reports/daily.rb'
 
  Formats = [
    ['Project Summary', 'ProjectSummary'],
    ['Project Summary & Description', 'ProjectSummaryDescription'],
    ['Activity Each', 'ActivityEach'],
    ['Activity Detail', 'ActivityDetail'],
    #['Daily Activity', 'Daily'],
  ]
      
end
