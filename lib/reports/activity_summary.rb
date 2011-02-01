module Reports
class ActivitySummary < Base
   
  FILE_EXT = 'txt'
  Summary = Struct.new(:name, :minutes, :url)
    
  def initialize(start_date, end_date, project, user)
    super(start_date, end_date, project, user)
    @data = {} # FAILS: Hash.new(Summary.new(0, nil))
    
    add_header_lines
    
    each_project_each_activity(@project)

    add_final_totals_lines
  end
  
  def add_header_lines
    add_line( [
      'Dates', 
      "From #{@start_date.strftime('%Y-%m-%d')}", 
      "Until #{@end_date.strftime('%Y-%m-%d')}"
    ] )
  end
    
  def each_activity(project)
    project_activities(project).each { |activity|
      id = activity.project.id
      @data[id] ||= Summary.new(activity.project.name, 0, nil)
      @data[id].minutes += activity.minutes
      @data[id].url ||= activity.project.url
    }
  end
  
  def add_final_totals_lines()
    add_blank_line

    @data.keys.sort { |a, b| @data[a].name <=> @data[b].name }.each { |e| 
      add_line( [ '  ', format_hours(@data[e].minutes() /60.0), @data[e].name, @data[e].url ] ) 
    } 

    add_blank_line
    add_line( [
      'Total Hours'
    ] )
    add_line( [
      '', total_hours
    ] )
    
    add_blank_line
    add_line( ['Report generated at', Time.now.to_s] )
  end
  
  def total_hours
    format_hours( @data.keys.inject(0) { |memo, e| memo + @data[e].minutes } / 60.0 )
  end
  
  def render
    @lines.map { |e| e.join("\t") }.join("\n")
  end
  
end
end
