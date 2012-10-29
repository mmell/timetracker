module Reports
  class ProjectSummaryDescription < ProjectSummary
    
    def each_activity(project)
      project_activities(project).each { |activity|
        name = [activity.project.fullname, activity.description].delete_if(&:blank?).join("::")
        @data[name] ||= Summary.new(name, 0, nil)
        @data[name].minutes += activity.minutes
        @data[name].url ||= activity.project.url
      }
    end

  end
end
