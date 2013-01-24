module Reports
  class ActivityEach < Base 

    FILE_EXT = 'csv'
    Columns = [
      'Minutes',
      'End Time',
      'Project',
      'Description',
    ]
    
    def initialize(start_date, end_date, project, user)
      super(start_date, end_date, project, user)
      add_line( ['Activities'] ) 
      add_line( Columns ) 
      each_project_each_activity(project)
    end
    
    def each_activity(project)
      project_activities(project).each { |activity|
        add_activity_line(activity)
      }
    end
  
    def add_activity_line(activity)
      add_line( [
        activity.minutes, 
        activity.local_stop_time, 
        activity.project.name,
        activity.description.to_s.strip
      ])
    end
  
    def render
      @lines.map { |e| CSV.generate_line( e ) }.join('')
    end
  
  end
end
