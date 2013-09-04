module Reports
  class ProjectSummaryDescription < ProjectSummary

    def activity_name(activity)
      [activity.project.fullname, activity.description].delete_if(&:blank?).join(" — ")
    end

  end
end
